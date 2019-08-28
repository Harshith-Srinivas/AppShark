window.ModalManager = function (component, AppConfig, ecId, Localization) {
    const NamespaceService = AppConfig.NamespaceService;
    const DatabaseService = AppConfig.GlobalActions.getDatabaseService ? AppConfig.GlobalActions.getDatabaseService(NamespaceService) : {};
    const DatabaseObjects = window.DatabaseObjects ? window.DatabaseObjects : {};
    const systemUtils = window.SystemUtils ? window.SystemUtils : {};

    function ModalActionScope(action, cb, visible) {
        this.action = action; //String
        this.callback = cb; //Callback function
        this.visible = typeof visible === 'undefined' || visible === null ? false : visible;
    }
    
    function ModalAction (ecId) {
        this.Type = {};
        this.ecId = ecId;
        this.Salesforce = {};
        this.Salesforce.sourceId = ecId;
        this.Fields = {};
        this.Collection = {};
        this.SaveOptions = {};
        this.SaveOptions.enabled = true;
        this.ChildActions = [];
        this.CallBackAction = {};
        this.recordWrapper = {};
        this.next = null;
        this.previous = null;
        this.viewStateId = null;
        this.currentScope = this;
    }
    
    ModalAction.prototype.cache = function(mComponent) {
        mComponent.set('v.ModalAction', this);
        window.ModalAction = this;
    };
    
    ModalAction.prototype.changeModalActionScope = function(scope, previous, mComponent) {
        if (!scope && !previous) return;
        scope.previous = previous; //Change previous 
        mComponent.set('v.ModalAction', scope);
        window.ModalAction = scope; 
    };
    
    ModalAction.prototype.addSigningGroup = function(sg) {
        this.recordWrapper = DatabaseService.newRecipient(AppConfig.Recipients === undefined ? 1 : AppConfig.Recipients.length + 1, 'CRL Signing Group', this.ecId);
        this.recordWrapper.SigningGroupId__c = sg;
        this.recordWrapper.SigningGroupName__c = DatabaseObjects.signingGroups[sg].name;
        this.recordWrapper.members = DatabaseObjects.getSigningGroupMembers(sg);
    };
    
    ModalAction.prototype.addTemplates = function(templates, parentComponent) { //Array of templateIds 
        let results = [];
        let ecId = this.ecId;
        let order = AppConfig.Documents.length + 1;
        templates.forEach(function(templateId){
            let templateDoc = DatabaseService.newDocument(order++, 'DSTemplate', ecId);    
            templateDoc.Name__c = DatabaseObjects.templates[templateId].name;
            templateDoc.Value__c = templateId;
            results.push(templateDoc);
        });
        DatabaseService.bulkInsert(results, parentComponent).then(function() {
            AppConfig.refresh();
        }).catch(function(results){
            AppConfig.throwGenericError();
        });;
    };

    ModalAction.prototype.getNewParameter = function(ecId) {
        let self = this;
        return DatabaseService.newAdvancedParameter(self.ecId);
    };

    ModalAction.prototype.getNextAction = function(params, mComponent) {
        //Create handlers for each ModalAction that contains next actions
        let next;
        let self = this;
        switch (this.next.action) {
            case 'Delete Layout':
                next = this.next.callback(params.layoutKey, params.layoutId, params.recordId);    
                break;
            case 'Edit Signing Group':
                next = this.next.callback(this.ecId, this.recordWrapper, this);
                break;
        }
        if (next) self.changeModalActionScope(next, self, mComponent);
    };
    
    ModalAction.prototype.getPreviousAction = function(params) {
        //Create handlers for each ModalAction that contains next actions
        let self = this;
        self.changeModalActionScope(this.previous, this.previous.previous ? this.previous.previous : null);
    };   

    ModalAction.prototype.addAdvancedParameter = function(param) {
        if (!this.newParameters) this.newParameters = [];
        this.newParameters.push(param);
        this.SaveOptions.enabled = true;
    }; 

    ModalAction.prototype.updateAdvancedParameter = function(param) {
        if (!this.newParameters) this.newParameters = [];
        this.updateParameters.push(param);
        this.SaveOptions.enabled = true;
    };  

    ModalAction.prototype.saveAdvancedParameters = function(params) {
        if (!params || !params.length || params.length === 0) return;
        let newParams = [];
        let updateParams = [];
        params.forEach(function(param) {
            if (!param.Id || param.Id === null) newParams.push(param);
            else updateParams.push(param);
        });
        console.log(updateParams);
        console.log(newParams);
        Promise.all([DatabaseService.bulkInsert(newParams), DatabaseService.bulkUpdate(updateParams)]).then(function(){
            AppConfig.refresh();
        }).catch(function(results) {
            AppConfig.throwGenericError();
        });
    };   
    
    ModalAction.prototype.disableSave = function(mComponent, SaveOptionValue) {
        if (!this.SaveOptions || this.SaveOptions === null) return;
        mComponent.set("v.SaveOptionsEnabled", SaveOptionValue);
    };     
    
    const buildDefaultModalAction = function (ecId) {
        return new ModalAction(ecId);
    };

    const generateSuccessMessage = function(title) {
        return Localization.labels['EnvelopeConfigurationSaveSuccess'].replace('{0}', title);
    };

    const buildModalAction = function (actionSource, event) {
        return new Promise(function(resolve, reject) {
            switch (actionSource) {
                //Recipient Modal Actions
            case 'crl_recipient':
                resolve(getCRLModalAction(AppConfig, 'NEW', ecId, event, component));
            case 'edit_crl_recipient':
                resolve(getCRLModalAction(AppConfig, 'EDIT', ecId, event, component));
                //Salesforce Refrences (Objects & CRCL)
            case 'crcl_recipient':
                resolve(getCRCLModalAction(AppConfig, 'NEW', ecId, event, component));
            case 'add_user':
                resolve(getCRCLModalAction(AppConfig, 'NEW', ecId, event, component));
            case 'add_contact':
                resolve(getCRCLModalAction(AppConfig, 'NEW', ecId, event, component));
            case 'add_lead':
                resolve(getCRCLModalAction(AppConfig, 'NEW', ecId, event, component));
            case 'edit_user':
                resolve(getCRCLModalAction(AppConfig, 'NEW', ecId, event, component));
            case 'edit_contact':
                resolve(getCRCLModalAction(AppConfig, 'NEW', ecId, event, component));
            case 'edit_lead':
                resolve(getCRCLModalAction(AppConfig, 'NEW', ecId, event, component));
            case 'edit_crcl_recipient':
                resolve(getCRCLModalAction(AppConfig, 'EDIT', ecId, event, component));
            case 'add_sg':
                resolve(getSGModalAction(AppConfig, ecId, event, component));
                //Document Modal Actions
            case 'file_doc':
                resolve(getFileUploadModalAction(AppConfig, ecId, event, component));
            case 'dst_doc':
                resolve(getDSTModalAction(AppConfig, ecId, event, component));
                //Role Mapping Modal Actions
            case 'ccrm_map':
                resolve(getCCRMModalAction(AppConfig, 'NEW', ecId, event, component));
            case 'edit_ccrm_map':
                resolve(getCCRMModalAction(AppConfig, 'EDIT', ecId, event, component));
            case 'cctm_map':
                resolve(getCCTMModalAction(AppConfig, 'NEW', ecId, event, component));
            case 'edit_cctm_map':
                resolve(getCCTMModalAction(AppConfig, 'EDIT', ecId, event, component));
            case 'ccnm_map':
                resolve(getCCNMModalAction(AppConfig, 'NEW', ecId, event, component));
            case 'edit_ccnm_map':
                resolve(getCCNMModalAction(AppConfig, 'EDIT', ecId, event, component));
                //Layout Modal Actions
            case 'add_layout':
                resolve(getLayoutAssignModalAction(AppConfig, ecId, event, component));
            case 'manage_layouts':
                resolve(getLayoutManageModalAction(AppConfig, ecId, event, component));
                //View resources (DocuSign Templates & Salesforce Files)
            case 'view_dst':
                resolve(getDocuSignResourceModalAction(AppConfig, ecId, event, component));
            case 'view_file':
                resolve(getSalesforceResourceModalAction(AppConfig, ecId, event, component));
            case 'advanced_parameters':
                resolve(getAdvancedParametersAction(AppConfig, ecId, event, component));           
            }
        });
    };

    const getAdvancedParametersAction = async function(AppConfig, ecId, event, component) {
        let ModalAction = buildDefaultModalAction(ecId);
        ModalAction.AdvancedParameters = systemUtils.toList(AppConfig.AdvancedParameters);
        ModalAction.ParameterTypes = await AppConfig.getAdvancedParameterOptions();
        ModalAction.Type.Category = 'Advanced';
        ModalAction.Type.Variation = 'AdvancedParameters';
        ModalAction.Title = Localization.labels['AdvancedParameters'];
        ModalAction.PostSaveMessage = generateSuccessMessage(ModalAction.Title);
        ModalAction.Icon = Localization.images['SettingIcon'];
        ModalAction.Salesforce.Action = 'ViewAdvancedParameters';
        ModalAction.Header = Localization.labels['ManageAdvancedParameters'];
        ModalAction.SaveOptions.label = Localization.labels['Save'];
        ModalAction.SaveOptions.enabled = true;
        return ModalAction;        
    };

    const getCRLModalAction = function (AppConfig, type, ecId, event, component) {
        let ModalAction = buildDefaultModalAction(ecId);
        ModalAction.Type.Category = 'Recipient';
        ModalAction.Type.Variation = 'CRL';
        ModalAction.Salesforce.sObject = NamespaceService.sObjects['Recipient__c'];
        ModalAction.Title = 'DocuSign Recipent';
        ModalAction.PostSaveMessage = generateSuccessMessage(ModalAction.Title);
        ModalAction.Icon = Localization.images['RecipientIcon'];

        if (type === 'EDIT') {
            let recipientInContext = event.target.getAttribute('data-sfid');
            ModalAction.Header = 'Edit Recipient';
            ModalAction.Salesforce.Action = 'Edit';
            ModalAction.Salesforce.Id = recipientInContext;
            ModalAction.recordWrapper = DatabaseService.getRecord(recipientInContext, AppConfig.Recipients);
        } else if (type === 'NEW') {
            ModalAction.Header = 'New Recipient';
            ModalAction.Salesforce.Action = 'New';
            ModalAction.Salesforce.Order = AppConfig.Recipients === undefined ? 1 : AppConfig.Recipients.length + 1;
            ModalAction.recordWrapper = DatabaseService.newRecipient(ModalAction.Salesforce.Order, ModalAction.Type.Variation, ecId);
        }
        ModalAction.SaveOptions.label = Localization.labels["SaveRecipient"]; 
        ModalAction.SaveOptions.enabled = true;
        return ModalAction;
    };

    const getAddUserModalAction = function (ModalAction) {
        ModalAction.Type.Category = 'Recipient';
        ModalAction.Type.Variation = 'User';
        ModalAction.Header = 'Select User';
        return ModalAction;
    };

    const getAddLeadModalAction = function (ModalAction) {
        ModalAction.Type.Category = 'Recipient';
        ModalAction.Type.Variation = 'Lead';
        ModalAction.Header = 'Select Lead';
        return ModalAction;
    };

    const getAddContactModalAction = function (ModalAction) {
        ModalAction.Type.Category = 'Recipient';
        ModalAction.Type.Variation = 'Contact';
        ModalAction.Header = 'Select Contact';
        return ModalAction;
    };

    const getAddReferenceRecipientModalAction = function (AppConfig, type, objectType, ecId, data, component) {
        let ModalAction = buildDefaultModalAction(ecId);
        ModalAction.Icon = Localization.images['RecipientIcon'];
        ModalAction.Salesforce.sObject = NamespaceService.sObjects['Recipient__c'];
        ModalAction.Title = 'DocuSign Recipent';
        ModalAction.PostSaveMessage = generateSuccessMessage(ModalAction.Title);
        switch (objectType) {
        case 'User':
            ModalAction.getAddUserModalAction(ModalAction);
        case 'Lead':
            ModalAction.getAddLeadModalAction(ModalAction);
        case 'Contact':
            ModalAction.getAddContactModalAction(ModalAction);
        }

        if (type === 'EDIT') {
            let recipientInContext = event.target.getAttribute('data-sfid');
            ModalAction.Header = 'Edit Recipient';
            ModalAction.Salesforce = {};
            ModalAction.Salesforce.Action = 'Edit';
            ModalAction.recordWrapper = DatabaseService.getRecord(recipientInContext, AppConfig.Recipients);
            ModalAction.Salesforce.Id = recipientInContext;
        } else if (type === 'NEW') {
            ModalAction.Header = 'New Recipient';
            ModalAction.Salesforce.Action = 'New';
            ModalAction.Salesforce.Order = AppConfig.Recipients === undefined ? 1 : AppConfig.Recipients.length + 1;
            ModalAction.recordWrapper = DatabaseService.newRecipient(ModalAction.Salesforce.Order, ModalAction.Type.Variation, ecId);
        }
        ModalAction.SaveOptions.label = Localization.labels["SaveRecipient"];
        ModalAction.SaveOptions.enabled = true;
        return ModalAction;
    };

    let getSigningGroupModalAction = function (AppConfig, type, ecId, data, component) {
        let ModalAction = buildDefaultModalAction(ecId);
        ModalAction.Type.Category = 'Recipient';
        ModalAction.Type.Variation = 'Signing Group';
        ModalAction.Salesforce.sObject = NamespaceService.sObjects['Recipient__c'];
        ModalAction.Title = 'DocuSign Signing Group';
        ModalAction.PostSaveMessage = generateSuccessMessage(ModalAction.Title);
        ModalAction.Icon = Localization.images['RecipientIcon'];

        if (type === 'EDIT') {
            let recipientInContext = event.target.getAttribute('data-sfid');
            ModalAction.Header = 'Edit Recipient';
            ModalAction.Salesforce = {};
            ModalAction.Salesforce.Action = 'Edit';
            ModalAction.recordWrapper = DatabaseService.getRecord(recipientInContext, AppConfig.Recipients);
            ModalAction.Salesforce.Id = recipientInContext;
        } else if (type === 'NEW') {
            ModalAction.Header = 'New Recipient';
            ModalAction.Salesforce.Action = 'New';
            ModalAction.Salesforce.Order = AppConfig.Recipients === undefined ? 1 : AppConfig.Recipients.length + 1;
            ModalAction.recordWrapper = DatabaseService.newRecipient(ModalAction.Salesforce.Order, ModalAction.Type.Variation, ecId);
        }
        ModalAction.next = new ModalActionScope('Edit Signing Group', getSGChainModalAction, true);
        ModalAction.SaveOptions.enabled = false;
        return ModalAction;
    };

    const getCRCLModalAction = function (AppConfig, type, ecId, event, component) {
        let ModalAction = buildDefaultModalAction(ecId);
        ModalAction.Type.Category = 'Recipient';
        ModalAction.Type.Variation = 'CRCL';
        ModalAction.Salesforce.sObject = NamespaceService.sObjects['Recipient__c'];
        ModalAction.Salesforce.sourceId = ecId;
        ModalAction.Title = 'DocuSign Recipent';
        ModalAction.PostSaveMessage = generateSuccessMessage(ModalAction.Title);
        ModalAction.Icon = Localization.images['RecipientIcon'];

        if (type === 'EDIT') {
            let recipientInContext = event.target.getAttribute('data-sfid');
            ModalAction.Header = 'Edit Recipient';
            ModalAction.Salesforce = {};
            ModalAction.Salesforce.Action = 'Edit';
            ModalAction.Salesforce.Id = recipientInContext;
            ModalAction.recordWrapper = DatabaseService.getRecord(recipientInContext, AppConfig.Recipients);
            ModalAction.Salesforce.BaseObject = AppConfig.BaseObject;

        } else if (type === 'NEW') {
            ModalAction.Header = 'Add Salesforce Refrence';
            ModalAction.Salesforce.Action = 'New';
            ModalAction.Salesforce.Order = AppConfig.Recipients === undefined ? 1 : AppConfig.Recipients.length + 1;
            ModalAction.recordWrapper = DatabaseService.newRecipient(ModalAction.Salesforce.Order, ModalAction.Type.Variation, ecId);
            ModalAction.Salesforce.BaseObject = AppConfig.BaseObject;
        }
        ModalAction.SaveOptions.label = Localization.labels["SaveRecipient"];
        ModalAction.SaveOptions.enabled = true;
        return ModalAction;
    };

    const getCCRMModalAction = function (AppConfig, type, ecId, event, component) {
        let ModalAction = buildDefaultModalAction(ecId);
        ModalAction.Type.Category = 'Map';
        ModalAction.Type.Variation = 'CCRM';
        ModalAction.Salesforce.sObject = NamespaceService.sObjects['CustomParameterMap__c'];
        ModalAction.Title = 'Custom Contact Role Mapping';
        ModalAction.PostSaveMessage = generateSuccessMessage(ModalAction.Title);
        ModalAction.Icon = Localization.images['RecipientIcon'];
        ModalAction.Fields.MapName = 'Salesforce Role';
        ModalAction.Fields.MapValue = 'DocuSign Role';

        if (type === 'EDIT') {
            let mapInContext = event.target.getAttribute('data-sfid');
            ModalAction.Header = 'Edit Custom Contact Role Mapping';
            ModalAction.Salesforce.Action = 'Edit';
            ModalAction.Salesforce.Id = mapInContext;
            ModalAction.Salesforce.sObject = NamespaceService.sObjects['CustomParameterMap__c'];
            ModalAction.recordWrapper = DatabaseService.getRecord(mapInContext, AppConfig.Mappings.CCRM);
        } else if (type === 'NEW') {
            ModalAction.Header = Localization.labels['NewRoleMapping'];
            ModalAction.Salesforce.Action = 'New';
            ModalAction.recordWrapper = DatabaseService.newMapping(ModalAction.Type.Variation, ecId);
        }
        ModalAction.SaveOptions.label = Localization.labels['Save'];
        ModalAction.SaveOptions.enabled = true;
        return ModalAction;
    };

    const getCCTMModalAction = function (AppConfig, type, ecId, event, component) {
        let ModalAction = buildDefaultModalAction(ecId);
        ModalAction.Type.Category = 'Map';
        ModalAction.Type.Variation = 'CCTM';
        ModalAction.Salesforce.sObject = NamespaceService.sObjects['CustomParameterMap__c'];
        ModalAction.Title = 'Custom Contact Type Mapping';
        ModalAction.PostSaveMessage = generateSuccessMessage(ModalAction.Title);
        ModalAction.Icon = Localization.images['RecipientIcon'];
        ModalAction.Fields.MapName = 'Role';
        ModalAction.Fields.MapValue = 'Type';

        if (type === 'EDIT') {
            let mapInContext = event.target.getAttribute('data-sfid');
            ModalAction.Header = 'Edit Custom Contact Role Mapping';
            ModalAction.Salesforce.Action = 'Edit';
            ModalAction.Salesforce.Id = mapInContext;
            ModalAction.Salesforce.sObject = NamespaceService.sObjects['CustomParameterMap__c'];
            ModalAction.recordWrapper = DatabaseService.getRecord(mapInContext, AppConfig.Mappings.CCTM);
        } else if (type === 'NEW') {
            ModalAction.Header = Localization.labels['NewTypeMapping'];
            ModalAction.Salesforce.Action = 'New';
            ModalAction.recordWrapper = DatabaseService.newMapping(ModalAction.Type.Variation, ecId);
        }
        ModalAction.SaveOptions.label = Localization.labels['Save'];
        ModalAction.SaveOptions.enabled = true;
        return ModalAction;
    };

    const getCCNMModalAction = function (AppConfig, type, ecId, event, component) {
        ModalAction = buildDefaultModalAction(ecId);
        ModalAction.Type.Category = 'Map';
        ModalAction.Type.Variation = 'CCTM';
        ModalAction.Salesforce.sObject = NamespaceService.sObjects['CustomParameterMap__c'];
        ModalAction.Title = 'Custom Contact Note Mapping';
        ModalAction.PostSaveMessage = generateSuccessMessage(ModalAction.Title);
        ModalAction.Icon = Localization.images['RecipientIcon'];
        ModalAction.Fields.MapName = 'Role';
        ModalAction.Fields.MapValue = 'Note';

        if (type === 'EDIT') {
            let mapInContext = event.target.getAttribute('data-sfid');
            ModalAction.Header = 'Edit Custom Contact Role Mapping';
            ModalAction.Salesforce.Action = 'Edit';
            ModalAction.Salesforce.Id = mapInContext;
            ModalAction.Salesforce.sObject = NamespaceService.sObjects['CustomParameterMap__c'];
            ModalAction.recordWrapper = DatabaseService.getRecord(mapInContext, AppConfig.CCNM);
        } else if (type === 'NEW') {
            ModalAction.Header = 'New Role Mapping';
            ModalAction.Salesforce.Action = 'New';
            ModalAction.recordWrapper = DatabaseService.newRecipient(ModalAction.Type.Variation, ecId);
        }
        ModalAction.SaveOptions.label = Localization.labels['Save'];
        ModalAction.SaveOptions.enabled = true;
        return ModalAction;
    };

    const getDSTModalAction = function (AppConfig, ecId, event, component) {
        let ModalAction = buildDefaultModalAction(ecId);
        ModalAction.Type.Category = 'Document';
        ModalAction.Type.Variation = 'DSTemplate';
        ModalAction.Salesforce.sObject = NamespaceService.sObjects['CustomParameterMap__c'];
        ModalAction.Title = 'DocuSign Template';
        ModalAction.PostSaveMessage = generateSuccessMessage(ModalAction.Title);
        ModalAction.Icon = Localization.images['DocumentIcon'];
        ModalAction.Salesforce.Action = 'DST';
        ModalAction.Header = 'Select DocuSign Template';
        ModalAction.Salesforce.Order = AppConfig.Documents === undefined ? 1 : AppConfig.Documents.length + 1;
        ModalAction.Salesforce.Url = NamespaceService.paths['envelopeconfigurationmodal'] + '?ecId=' + ecId + '&Action=DST';
        ModalAction.SaveOptions.label = Localization.labels['AddTemplate'] + '(s)';
        ModalAction.recordWrapper = DatabaseService.newDocument(AppConfig.Documents.length + 1, ModalAction.Type.Variation, ecId);
        ModalAction.Templates = Object.values(DatabaseObjects.templates);
        ModalAction.selectedTemplates = [];
        ModalAction.SaveOptions.enabled = ModalAction.Templates && ModalAction.Templates.length > 0 ? true : false;

        return ModalAction;
    };

    const getSGModalAction = function (AppConfig, ecId, event, component) {
        let ModalAction = buildDefaultModalAction(ecId);
        ModalAction.Type.Category = 'Recipient';
        ModalAction.Type.Variation = 'SG';
        ModalAction.Salesforce.sObject = NamespaceService.sObjects['Recipient__c'];
        ModalAction.Title = 'DocuSign Signing Group';
        ModalAction.PostSaveMessage = generateSuccessMessage(ModalAction.Title);
        ModalAction.Icon = Localization.images['RecipientIcon'];
        ModalAction.Salesforce.Action = 'SG';
        ModalAction.Header = 'Select DocuSign Signing Group';
        ModalAction.Salesforce.Order = AppConfig.Recipients === undefined ? 1 : AppConfig.Recipients.length + 1;
        ModalAction.Salesforce.Url = NamespaceService.paths['envelopeconfigurationmodal'] + '?ecId=' + ecId + '&Action=SG';
        ModalAction.SaveOptions.label = 'Add Signing Group';
        ModalAction.SaveOptions.enabled = false;
        ModalAction.next = new ModalActionScope('Edit Signing Group', getSGChainModalAction, true);
        ModalAction.SigningGroups = Object.values(DatabaseObjects.signingGroups);        
        ModalAction.SaveOptions.enabled = ModalAction.SigningGroups && ModalAction.SigningGroups.length > 0 ? true : false;
        return ModalAction;
    };

    const getFileUploadModalAction = function (AppConfig, ecId, event, component) {
        let ModalAction = buildDefaultModalAction(ecId);
        ModalAction.Type.Category = 'Document';
        ModalAction.Type.Variation = 'File Upload';
        ModalAction.Salesforce.sObject = NamespaceService.sObjects['CustomParameterMap__c'];
        ModalAction.Title = 'File Upload';
        ModalAction.PostSaveMessage = generateSuccessMessage(ModalAction.Title);
        ModalAction.Icon = Localization.images['DocumentIcon'];
        ModalAction.Salesforce.Action = 'New';
        ModalAction.Header = 'File Upload';
        ModalAction.SaveOptions.enabled = false;
        ModalAction.Salesforce.Order = AppConfig.Documents === undefined ? 1 : AppConfig.Documents.length + 1;
        ModalAction.recordWrapper = DatabaseService.newDocument(AppConfig.Documents.length + 1, ModalAction.Type.Variation, ecId);

        return ModalAction;
    };

    const getLayoutAssignModalAction = function (AppConfig, ecId, event, component) {
        let ModalAction = buildDefaultModalAction(ecId);
        ModalAction.Type.Category = 'Layout';
        ModalAction.Type.Variation = 'Layout Assignment';
        ModalAction.Salesforce.sObject = NamespaceService.sObjects['CustomParameterMap__c'];
        ModalAction.Title = 'Layout Assignment';
        ModalAction.PostSaveMessage = generateSuccessMessage(ModalAction.Title);
        ModalAction.Icon = Localization.images['SettingIcon'];
        ModalAction.Salesforce.Action = 'Layout';
        ModalAction.Header = 'Add to Object Layout';
        ModalAction.Salesforce.Url = NamespaceService.paths['envelopeconfigurationmodal'] + '?ecId=' + ecId + '&Action=LAYOUT';
        ModalAction.SaveOptions.label = Localization.labels['AddLayoutAssignment'];
        ModalAction.SaveOptions.enabled = true;

        return ModalAction;
    };

    const getClassicLayoutAssignModalAction = function (ecId, previous) {
        let ModalAction = buildDefaultModalAction(ecId);
        ModalAction.Type.Category = 'Layout';
        ModalAction.Type.Variation = 'Layout Assignment';
        ModalAction.Salesforce.sObject = NamespaceService.sObjects['CustomParameterMap__c'];
        ModalAction.Title = 'Layout Assignment';
        ModalAction.PostSaveMessage = generateSuccessMessage(ModalAction.Title);
        ModalAction.Icon = Localization.images['SettingIcon'];
        ModalAction.Salesforce.Action = 'Layout';
        ModalAction.Header = 'Add to Classic Layout';
        ModalAction.Salesforce.Url = NamespaceService.paths['envelopeconfigurationmodal'] + '?ecId=' + ecId + '&Action=LAYOUT&Type=Classic';
        ModalAction.SaveOptions.label = Localization.labels['AddLayoutAssignment'];
        ModalAction.SaveOptions.enabled = false;
        ModalAction.previous = previous;

        return ModalAction;
    };

    const getDeleteLayoutAction = function (layoutKey, layoutId, ecId) {
        let ModalAction = buildDefaultModalAction(ecId);
        ModalAction.Type.Category = 'Layout';
        ModalAction.Type.Variation = 'Delete Layout';
        ModalAction.Salesforce.sObject = NamespaceService.sObjects['CustomParameterMap__c'];
        ModalAction.Title = 'Delete Layout';
        ModalAction.PostSaveMessage = generateSuccessMessage(ModalAction.Title);
        ModalAction.Icon = Localization.images['RecipientIcon'];
        ModalAction.Salesforce.Action = 'DeleteLayout';
        ModalAction.Header = 'Delete Layout';
        ModalAction.Salesforce.Url = NamespaceService.paths['envelopeconfigurationmodal'] + '?ecId=' + ecId + '&Action=ButtonDelete&LayoutKey=' + layoutKey + '&LayoutId=' + layoutId;
        ModalAction.SaveOptions.label = Localization.labels['Confirm'];
        ModalAction.SaveOptions.enabled = true;
        return ModalAction;
    };
    
    const getSGChainModalAction = function (ecId, recordWrapper, previous) {
        let ModalAction = buildDefaultModalAction(ecId);
        ModalAction.Type.Category = 'Recipient';
        ModalAction.Type.Variation = 'CRL';
        ModalAction.Type.Action = 'SG';
        ModalAction.Salesforce.sObject = NamespaceService.sObjects['Recipient__c'];
        ModalAction.Title = 'DocuSign Recipent';
        ModalAction.PostSaveMessage = generateSuccessMessage(ModalAction.Title);
        ModalAction.Icon = Localization.images['RecipientIcon'];
        ModalAction.Header = 'Edit Signing Group Recipient';
        ModalAction.Salesforce.Action = 'New';
        ModalAction.Salesforce.Id = recordWrapper.Id;
        ModalAction.recordWrapper = recordWrapper;
        ModalAction.SaveOptions.label = Localization.labels["SaveRecipient"]; 
        ModalAction.SaveOptions.enabled = true;
        ModalAction.previous = previous;
        return ModalAction;
    };    

    const getLightningLayoutAssignModalAction = function (ecId, previous) {
        let ModalAction = buildDefaultModalAction(ecId);
        ModalAction.Type.Category = 'Layout';
        ModalAction.Type.Variation = 'Layout Assignment';
        ModalAction.Salesforce.sObject = NamespaceService.sObjects['CustomParameterMap__c'];
        ModalAction.Title = 'Layout Assignment';
        ModalAction.PostSaveMessage = generateSuccessMessage(ModalAction.Title);
        ModalAction.Icon = Localization.images['SettingIcon'];
        ModalAction.Salesforce.Action = 'Layout';
        ModalAction.Header = 'Add to Lightning Layout';
        ModalAction.Salesforce.Url = NamespaceService.paths['envelopeconfigurationmodal'] + '?ecId=' + ecId + '&Action=LAYOUT&Type=Lightning';
        ModalAction.SaveOptions.label = Localization.labels['AddLayoutAssignment'];
        ModalAction.SaveOptions.enabled = false;
        ModalAction.previous = previous;
        return ModalAction;
    };

    const getLayoutManageModalAction = function (AppConfig, ecId, event, component) {
        let ModalAction = buildDefaultModalAction(ecId);
        ModalAction.Type.Category = 'Layout';
        ModalAction.Type.Variation = 'Layout Manage';
        ModalAction.Salesforce.sObject = 'EnvelopeConfiguration__c';
        ModalAction.Title = 'Layout Assignment';
        ModalAction.PostSaveMessage = generateSuccessMessage(ModalAction.Title);
        ModalAction.Icon = Localization.images['SettingIcon'];
        ModalAction.Salesforce.Action = 'Layout';
        ModalAction.Header = 'Add to Object Layout';
        ModalAction.Salesforce.Url = NamespaceService.paths['envelopeconfigurationmodal'] + '?ecId=' + ecId + '&Action=LAYOUT';
        ModalAction.Collection.Layouts = AppConfig.Layouts;
        ModalAction.next = new ModalActionScope('Delete Layout', getDeleteLayoutAction);
        ModalAction.ChildActions.push({
            key: 'Add Classic Button',
            value: getClassicLayoutAssignModalAction(ecId, ModalAction)
        }, {
            key: 'Add Lightning Button',
            value: getLightningLayoutAssignModalAction(ecId, ModalAction)
        });        
        return ModalAction;
    };

    const getDocuSignResourceModalAction = function (AppConfig, ecId, event, component) { //TODO
        return null;
    };

    const getSalesforceResourceModalAction = function (AppConfig, ecId, event, component) {
        let ModalAction = buildDefaultModalAction(ecId);
        ModalAction.Type.Category = 'Salesforce File';
        ModalAction.Type.Variation = 'Salesforce Resource';
        ModalAction.Salesforce.sObject = NamespaceService.sObjects['CustomParameterMap__c'];
        ModalAction.Title = 'Salesforce File';
        ModalAction.PostSaveMessage = generateSuccessMessage(ModalAction.Title);
        ModalAction.Icon = Localization.images['DocumentIcon'];
        ModalAction.Salesforce.Action = 'Resource';
        ModalAction.Header = 'View Salesforce File';
        ModalAction.Salesforce.Id = event.target.getAttribute('data-sfid');

        return ModalAction;
    };

    const resetModal = function (ecId, component, data) {
        component.set("ModalAction", buildDefaultModalAction(ecId, data));
        toggleClassInverse(component, 'viewAllContentBackdrop', 'slds-backdrop--');
        toggleClassInverse(component, 'viewAllContent', 'slds-fade-in-');
    };

    return {
        getModal: buildModalAction
    };
};
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Core Data Service Entity'
define root view entity ZR_MRI_EDOC_OUT
as select from zmri_edoc_out as Invoice
{
key invoice               as Invoice,
comments              as Comments,      
@Semantics.mimeType: true
@UI.hidden: true
mimetypezip           as Mimetypezip,
///// zip /////
@Consumption.semanticObject: 'Document'
@EndUserText.label: 'Filename ZIP'
filenamezip           as Filenamezip,
@Semantics.largeObject:
{ mimeType: 'Mimetypezip',
fileName: 'Filenamezip',
contentDispositionPreference: #INLINE }
@EndUserText.label: 'ZIP'
zipdata               as zipdata,
@Semantics.user.createdBy: true
local_created_by      as LocalCreatedBy,
@Semantics.systemDateTime.createdAt: true
local_created_at      as LocalCreatedAt,
@Semantics.user.localInstanceLastChangedBy: true
local_last_changed_by as LocalLastChangedBy,
@Semantics.systemDateTime.localInstanceLastChangedAt: true
local_last_changed_at as LocalLastChangedAt,
@Semantics.systemDateTime.lastChangedAt: true
last_changed_at       as LastChangedAt,
from_edoc_custom      as FromEdocCustom

}

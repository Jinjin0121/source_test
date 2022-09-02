@AbapCatalog.sqlViewAppendName: 'ZC121EXT0003_V'
@EndUserText.label: '[C1] Fake Standard Table Extand'
extend view ZC121CDS0003 with ZC121EXT0003 {
    ztc1210003.zzsaknr,
    ztc1210003.zzkostl,
    ztc1210003.zzshkzg,
    ztc1210003.zzlgort
    
}

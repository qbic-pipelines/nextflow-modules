//
// Register H&E stained and multiplexed tissue images and transform segmentation masks using stainwarpy
//

include { TIF_REGISTRATION_STAINWARPY         } from '../../nf-core/tif_registration_stainwarpy/main'
include { STAINSEGMY                          } from '../../../modules/qbic/stainsegmy/main'        

workflow HE2MULTI_REGSEG {

    take:
    ch_hne              // channel: [ val(meta), path to .tif ]
    ch_multiplexed      // channel: [ val(meta), path to .tif ]

    main:

    STAINSEGMY ( ch_hne )

    TIF_REGISTRATION_STAINWARPY ( ch_hne, ch_multiplexed, STAINSEGMY.out.hne_seg_mask, 'multiplexed', 'multiplexed' )


    emit:
    transformed_image   = TIF_REGISTRATION_STAINWARPY.out.transformed_image                     // channel: [ val(meta), *_transformed_image.ome.tif             ]
    metrics             = TIF_REGISTRATION_STAINWARPY.out.metrics                               // channel: [ val(meta), *_registration_metrics_tform_map.json   ]
    transformed_segmask = TIF_REGISTRATION_STAINWARPY.out.transformed_segmask                   // channel: [ val(meta), *_transformed_segmentation_mask.ome.tif ]
}
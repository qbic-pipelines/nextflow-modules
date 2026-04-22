process STAINSEGMY {
    tag "$meta.id"
    label 'process_medium'
    label 'process_gpu'

    container "ghcr.io/tckumarasekara/stainsegmy-test:52d456d150fb9d4aee2c1ced75c1043a71e833b3"

    input:
    tuple val(meta), path(hne_img)

    output:
    tuple val(meta), path("*_hne_segmentation_mask.ome.tif")                     , emit: hne_seg_mask
    tuple val("${task.process}"), val('stainsegmy'), eval("stainsegmy --version"), topic: versions, emit: versions_stainsegmy

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    """
    stainsegmy \\
        -i ${hne_img} \\
        -o . \\
        ${args} \\

    mv Segmentation_mask.ome.tif ${prefix}_hne_segmentation_mask.ome.tif
    """

    stub:
    def prefix = task.ext.prefix ?: "${meta.id}"
    """   
    touch ${prefix}_hne_segmentation_mask.ome.tif
    """
}

process MACSIMA2MC {
    tag "$meta.id"
    label 'process_single'

    container "ghcr.io/schapirolabor/macsima2mc:v1.2.15"

    input:
    tuple val(meta), path(bam)

    output:
    // TODO nf-core: Named file extensions MUST be emitted for ALL output channels
    tuple val(meta), path("*.bam"), emit: bam

    tuple val("${task.process}"), val('macsima2mc'), eval("macsima2mc --version"), topic: versions, emit: versions_macsima2mc

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    
    """
    macsima2mc \\
        -i ${bam} \\
        -o ${prefix}/ \\
        $args
    """

    stub:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    """
    echo $args
    
    touch ${prefix}.bam
    """
}

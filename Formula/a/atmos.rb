class Atmos < Formula
  desc "Universal Tool for DevOps and Cloud Automation"
  homepage "https:github.comcloudposseatmos"
  url "https:github.comcloudposseatmosarchiverefstagsv1.87.0.tar.gz"
  sha256 "c7ff3a36cb7ec0bd19d50d2dc981cacb93a1742eb18725992ac3371d6aab21fa"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "850c7c5d49c14f5462ebeb3edbf98ee17028c809e77f6c9cb749b42df15d7cbb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "850c7c5d49c14f5462ebeb3edbf98ee17028c809e77f6c9cb749b42df15d7cbb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "850c7c5d49c14f5462ebeb3edbf98ee17028c809e77f6c9cb749b42df15d7cbb"
    sha256 cellar: :any_skip_relocation, sonoma:         "c1a71845a6c9f2b3b250c5f6722ff8c8c2b6f760c45f06f7bd8743f75ee8e970"
    sha256 cellar: :any_skip_relocation, ventura:        "c1a71845a6c9f2b3b250c5f6722ff8c8c2b6f760c45f06f7bd8743f75ee8e970"
    sha256 cellar: :any_skip_relocation, monterey:       "c1a71845a6c9f2b3b250c5f6722ff8c8c2b6f760c45f06f7bd8743f75ee8e970"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3d427c3a96182a82e23ae65b31852779f3f49313f22b0b23cd462ba9882bbce2"
  end

  depends_on "go" => :build

  conflicts_with "tenv", because: "tenv symlinks atmos binaries"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X 'github.comcloudposseatmoscmd.Version=#{version}'")

    generate_completions_from_executable(bin"atmos", "completion")
  end

  test do
    # create basic atmos.yaml
    (testpath"atmos.yaml").write <<~EOT
      components:
        terraform:
          base_path: ".componentsterraform"
          apply_auto_approve: false
          deploy_run_init: true
          auto_generate_backend_file: false
        helmfile:
          base_path: ".componentshelmfile"
          kubeconfig_path: "devshm"
          helm_aws_profile_pattern: "{namespace}-{tenant}-gbl-{stage}-helm"
          cluster_name_pattern: "{namespace}-{tenant}-{environment}-{stage}-eks-cluster"
      stacks:
        base_path: ".stacks"
        included_paths:
          - "***"
        excluded_paths:
          - "globals***"
          - "catalog***"
          - "***globals*"
        name_pattern: "{tenant}-{environment}-{stage}"
      logs:
        verbose: false
        colors: true
    EOT

    # create scaffold
    mkdir_p testpath"stacks"
    mkdir_p testpath"componentsterraformtop-level-component1"
    (testpath"stackstenant1-ue2-dev.yaml").write <<~EOT
      terraform:
        backend_type: s3 # s3, remote, vault, static, etc.
        backend:
          s3:
            encrypt: true
            bucket: "eg-ue2-root-tfstate"
            key: "terraform.tfstate"
            dynamodb_table: "eg-ue2-root-tfstate-lock"
            acl: "bucket-owner-full-control"
            region: "us-east-2"
            role_arn: null
          remote:
          vault:

      vars:
        tenant: tenant1
        region: us-east-2
        environment: ue2
        stage: dev

      components:
        terraform:
          top-level-component1: {}
    EOT

    # create expected file
    (testpath"backend.tf.json").write <<~EOT
      {
        "terraform": {
          "backend": {
            "s3": {
              "workspace_key_prefix": "top-level-component1",
              "acl": "bucket-owner-full-control",
              "bucket": "eg-ue2-root-tfstate",
              "dynamodb_table": "eg-ue2-root-tfstate-lock",
              "encrypt": true,
              "key": "terraform.tfstate",
              "region": "us-east-2",
              "role_arn": null
            }
          }
        }
      }
    EOT

    system bin"atmos", "terraform", "generate", "backend", "top-level-component1", "--stack", "tenant1-ue2-dev"
    actual_json = JSON.parse(File.read(testpath"componentsterraformtop-level-component1backend.tf.json"))
    expected_json = JSON.parse(File.read(testpath"backend.tf.json"))
    assert_equal expected_json["terraform"].to_set, actual_json["terraform"].to_set
  end
end
class Atmos < Formula
  desc "Universal Tool for DevOps and Cloud Automation"
  homepage "https:github.comcloudposseatmos"
  url "https:github.comcloudposseatmosarchiverefstagsv1.85.0.tar.gz"
  sha256 "6fb8a513391965fb58de05de7f9d5061954b0ae6f85bf28ae7e5cbd14083739b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4e5c42a5ba3799821328fd6122584e40f41b27e70035e37aed5aa9f53cbbece6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4b82353f4fefa5ff173cfbbf16aaea152939b777557f7eedf6952e8b207ac5f3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9a80e37359b1ece32982314405e616faad262638927763a8f22e44e58a777a75"
    sha256 cellar: :any_skip_relocation, sonoma:         "e62e4199342806f01f069b300715a0a228d262fcb948f5fbefdc2671108be9a2"
    sha256 cellar: :any_skip_relocation, ventura:        "ced963719a79df34880b5e8d98cf85d32564ea39d8020b9084b4644122d7289e"
    sha256 cellar: :any_skip_relocation, monterey:       "4814338bfccbca89fb911d86a0946a455a52ce27804edeb94236ee593a3f26dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0f221cb7bc487d737386d4ec034390340f04c05256cbc88f35dac90a8495b6ea"
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
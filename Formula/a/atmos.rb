class Atmos < Formula
  desc "Universal Tool for DevOps and Cloud Automation"
  homepage "https:github.comcloudposseatmos"
  url "https:github.comcloudposseatmosarchiverefstagsv1.101.0.tar.gz"
  sha256 "a7709898241425a517c47747a6816a9e0de27a782a9413630a72fa831b7468f1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f44d8e3f0e8168cdcb3ec2c24da2a594b900b68cd81c9112582db3a3b41c14f0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f44d8e3f0e8168cdcb3ec2c24da2a594b900b68cd81c9112582db3a3b41c14f0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f44d8e3f0e8168cdcb3ec2c24da2a594b900b68cd81c9112582db3a3b41c14f0"
    sha256 cellar: :any_skip_relocation, sonoma:        "48d6e7596fc5c52a7d0053e5d8db8095ffb517e8842514341167b23b119c6de1"
    sha256 cellar: :any_skip_relocation, ventura:       "48d6e7596fc5c52a7d0053e5d8db8095ffb517e8842514341167b23b119c6de1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f7b94067deed78d81cbb70ab9e9307adedba74c82ffbb0ea096a769dc4e6da2d"
  end

  depends_on "go" => :build

  conflicts_with "tenv", because: "tenv symlinks atmos binaries"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X 'github.comcloudposseatmospkgversion.Version=#{version}'")

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

    assert_match "Atmos #{version}", shell_output("#{bin}atmos version")
  end
end
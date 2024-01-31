class Atmos < Formula
  desc "Universal Tool for DevOps and Cloud Automation"
  homepage "https:github.comcloudposseatmos"
  url "https:github.comcloudposseatmosarchiverefstagsv1.56.0.tar.gz"
  sha256 "961c7c5362fa8bba34525a38131d41c4810121e87cda5f36ae53cf995242339c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "183d2e87f527fe15389a5a5fdbe91a52f0c0ad0c09bb16324ed8b25f8d042256"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c6420da6f6a511df2e1c0ec2011c48ccdd3538232610cf142a1c4c307be03ecf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b3df5dda479125758f2b7aeb169f37398a984447b8f310d7ec292d20f4564209"
    sha256 cellar: :any_skip_relocation, sonoma:         "956b1200d37e1698a7e16d74c88b4c9f37825f03719ae98a1c51e7227a06ed7d"
    sha256 cellar: :any_skip_relocation, ventura:        "0fdf34be168a9a4f49f6ae01db08d87968bacbb5a78243313b6ab1340c790863"
    sha256 cellar: :any_skip_relocation, monterey:       "0a523c7a2168589b1600c61b865e1ec2b77ffe348097580dc3ac6abd957558ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "69d9e992f76cb3132d89a1ab06daa7275e759a1c86e7c9a535db6ba707ac9c78"
  end

  depends_on "go" => :build

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
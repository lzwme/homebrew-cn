class Atmos < Formula
  desc "Universal Tool for DevOps and Cloud Automation"
  homepage "https://atmos.tools"
  url "https://ghfast.top/https://github.com/cloudposse/atmos/archive/refs/tags/v1.228.0.tar.gz"
  sha256 "a540c367618716aaac4e953a82d2ed3664ea0f7dc12dc399d5b0be50ad06ab07"
  license "Apache-2.0"
  head "https://github.com/cloudposse/atmos.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2e557dc44b401fbc4b6161c36e51a644f41a5f4dec43485893ab40fa099acc71"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "630749777bc8905f19ffb33ffbd6fe3ecfcaae8e47a709d110299d62fc6ba714"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0a52925bbf1b0e62c41593d507a77cdf73a0a5c62104b2b9d1f8a18caf86b8c1"
    sha256 cellar: :any,                 arm64_linux:   "a6038e24d779872862bcba2b94e2878f333a8af822dc75873e2ab08e3c8a50bd"
    sha256 cellar: :any,                 x86_64_linux:  "806e37e2990137b4a8cc2094ed0c001401ac2d32a2cfa2f4335e82cdd93f29da"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build

  on_linux do
    depends_on "systemd" # libudev
  end

  conflicts_with "tenv", because: "tenv symlinks atmos binaries"

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?
    ENV["GOFIPS140"] = "latest"

    system "go", "build", *std_go_args(ldflags: "-X 'github.com/cloudposse/atmos/pkg/version.Version=#{version}'")

    generate_completions_from_executable(bin/"atmos", shell_parameter_format: :cobra)
  end

  test do
    # create basic atmos.yaml
    (testpath/"atmos.yaml").write <<~YAML
      components:
        terraform:
          base_path: "./components/terraform"
          apply_auto_approve: false
          deploy_run_init: true
          auto_generate_backend_file: false
        helmfile:
          base_path: "./components/helmfile"
          kubeconfig_path: "/dev/shm"
          helm_aws_profile_pattern: "{namespace}-{tenant}-gbl-{stage}-helm"
          cluster_name_pattern: "{namespace}-{tenant}-{environment}-{stage}-eks-cluster"
      stacks:
        base_path: "./stacks"
        included_paths:
          - "**/*"
        excluded_paths:
          - "globals/**/*"
          - "catalog/**/*"
          - "**/*globals*"
        name_pattern: "{tenant}-{environment}-{stage}"
      logs:
        file: "/dev/stderr"
        verbose: false
        colors: true
    YAML

    # create scaffold
    mkdir_p testpath/"stacks"
    mkdir_p testpath/"components/terraform/top-level-component1"
    (testpath/"stacks/tenant1-ue2-dev.yaml").write <<~YAML
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
    YAML

    # create expected file
    (testpath/"backend.tf.json").write <<~JSON
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
    JSON

    system bin/"atmos", "terraform", "generate", "backend", "top-level-component1", "--stack", "tenant1-ue2-dev"
    actual_json = JSON.parse(File.read(testpath/"components/terraform/top-level-component1/backend.tf.json"))
    expected_json = JSON.parse(File.read(testpath/"backend.tf.json"))
    assert_equal expected_json["terraform"].to_set, actual_json["terraform"].to_set

    assert_match "Atmos #{version}", shell_output("#{bin}/atmos version")
  end
end
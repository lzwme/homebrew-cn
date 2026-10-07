class OpenshiftCli < Formula
  desc "OpenShift command-line interface tools"
  homepage "https://www.openshift.com/"
  url "https://mirror.openshift.com/pub/openshift-v4/clients/ocp/4.22.16/openshift-client-src.tar.gz"
  # This project employs synchronized versioning so the sha256 may not change on version bumps
  sha256 "7c28591a2ea76c4564fcca1d90be073feff1bd3084ec5093d94cd79a2bea85e2"
  license "Apache-2.0"
  head "https://github.com/openshift/oc.git", shallow: false, branch: "main"

  livecheck do
    url "https://mirror.openshift.com/pub/openshift-v4/clients/ocp/stable/"
    regex(/href=.*?openshift-client-mac-(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3cd7854a6dd53cf8d9b8bab1639309e05f608d2badbacb671f0cde46a077cd06"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ff8e8eb5a9fb872edf59d0fb86bd49be6665b9fb6ff13e32a9bd60b62c050898"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "853cf1e9568b4a37bb0f71d536bd8c7a7626c8691698e4ee366232b6fdaa1069"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6876887e3b23cd1126335453360a536c9382a433f89a94bf089a3cd326c72dc6"
    sha256 cellar: :any,                 x86_64_linux:      "d07897ab3a36d9e87ae862691fd046c5ff2e6246cb37290aefaa5e4c2c33aba6"
  end

  depends_on "go" => :build
  uses_from_macos "krb5"

  # `test do` block connects to api.openshift.com
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
    os = OS.kernel_name.downcase
    revision = build.head? ? Utils.git_head : Pathname.pwd.basename.to_s.delete_prefix("oc-")

    # See https://github.com/Homebrew/brew/issues/14763
    ENV.O0 if OS.linux?

    system "make", "cross-build-#{os}-#{arch}", "OS_GIT_VERSION=#{version}", "SOURCE_GIT_COMMIT=#{revision}", "SHELL=/bin/bash"
    bin.install "_output/bin/#{os}_#{arch}/oc"
    generate_completions_from_executable(bin/"oc", shell_parameter_format: :cobra)
  end

  test do
    # Grab version details from built client
    version_raw = shell_output("#{bin}/oc version --client --output=json")
    version_json = JSON.parse(version_raw)

    # Ensure that we had a clean build tree
    assert_equal "clean", version_json["clientVersion"]["gitTreeState"]

    # Verify the built artifact matches the formula
    assert_match version_json["clientVersion"]["gitVersion"], "v#{version}"

    # Get remote release details
    release_raw = shell_output("#{bin}/oc adm release info #{version} --output=json")
    release_json = JSON.parse(release_raw)

    # Verify the formula matches the release data for the version
    assert_match version_json["clientVersion"]["gitCommit"],
      release_json["references"]["spec"]["tags"].find { |tag|
        tag["name"]=="cli"
      } ["annotations"]["io.openshift.build.commit.id"]

    # Test that we can generate and write a kubeconfig
    (testpath/"kubeconfig").write ""
    system "KUBECONFIG=#{testpath}/kubeconfig #{bin}/oc config set-context foo 2>&1"
    assert_match "foo", shell_output("KUBECONFIG=#{testpath}/kubeconfig #{bin}/oc config get-contexts -o name")
  end
end
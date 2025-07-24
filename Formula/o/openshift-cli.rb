class OpenshiftCli < Formula
  desc "OpenShift command-line interface tools"
  homepage "https://www.openshift.com/"
  url "https://mirror.openshift.com/pub/openshift-v4/clients/ocp/4.19.4/openshift-client-src.tar.gz"
  # This project employs synchronized versioning so the sha256 may not change on version bumps
  sha256 "4c23bda233eaac582b812b9d4783be71f218de5124d673b4325377e8f325be2c"
  license "Apache-2.0"
  head "https://github.com/openshift/oc.git", shallow: false, branch: "master"

  livecheck do
    url "https://mirror.openshift.com/pub/openshift-v4/clients/ocp/stable/"
    regex(/href=.*?openshift-client-mac-(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ece6e22812208aedd8df33018f7181f291e1efb0ca1eef2789435f1793dfcb87"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f62507de1ac9226da1e0f555e964e3f11f6a4f2b5bc66260ba02af74bef521ce"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fe82d58bb54c9c34aa0039448769ebf4156e87f9ffbaeb0943e24463ca82f767"
    sha256 cellar: :any_skip_relocation, sonoma:        "d0c9b4ee3aaeaa62d45246bbd52cd0126c6b9404663d10de19320ffd627e1fe8"
    sha256 cellar: :any_skip_relocation, ventura:       "7d66f6467cd867ac0579d91193f8874da03ac2aff7270b86bce7bf5aba58c976"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cbf37d40e06a66b1e2d2887b33bbe86450fc1281901385449a0263020e8cb393"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46dbde7264f3ada743c91867c8bfda41199c3bd1b6359357d7cd2351fb4bfcb2"
  end

  depends_on "go" => :build
  uses_from_macos "krb5"

  def install
    arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
    os = OS.kernel_name.downcase
    revision = build.head? ? Utils.git_head : Pathname.pwd.basename.to_s.delete_prefix("oc-")

    # See https://github.com/Homebrew/brew/issues/14763
    ENV.O0 if OS.linux?

    system "make", "cross-build-#{os}-#{arch}", "OS_GIT_VERSION=#{version}", "SOURCE_GIT_COMMIT=#{revision}", "SHELL=/bin/bash"
    bin.install "_output/bin/#{os}_#{arch}/oc"
    generate_completions_from_executable(bin/"oc", "completion")
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
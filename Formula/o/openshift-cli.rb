class OpenshiftCli < Formula
  desc "OpenShift command-line interface tools"
  homepage "https://www.openshift.com/"
  url "https://mirror.openshift.com/pub/openshift-v4/clients/ocp/4.19.6/openshift-client-src.tar.gz"
  # This project employs synchronized versioning so the sha256 may not change on version bumps
  sha256 "4c23bda233eaac582b812b9d4783be71f218de5124d673b4325377e8f325be2c"
  license "Apache-2.0"
  head "https://github.com/openshift/oc.git", shallow: false, branch: "master"

  livecheck do
    url "https://mirror.openshift.com/pub/openshift-v4/clients/ocp/stable/"
    regex(/href=.*?openshift-client-mac-(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ecb63569a2758f19065f69b61c43805a5e2cb49e5478bb3d68ae0e3f6c7e21ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6370518a9c279af8ccc2fbb0ae53e7a50598882dbe293fd1e2326bc7bc1769b1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d81b34e4757b9765d51ae2c9884bc6457faeee6eba524244235c2f995cd9d295"
    sha256 cellar: :any_skip_relocation, sonoma:        "18c79320f0d590c4d0aa86f3e1e8dfa7efae9067f2870052f295fdd137d53683"
    sha256 cellar: :any_skip_relocation, ventura:       "c864916507ee6a6482b504b4d3e22e04f0058510beec8d90b35e99641e9f2220"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "46669fa0c68c95b770b38944f7e860358a6c33c2b7f1cb123845303e251bb2d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b9bd978e067226725c86b00abe9c4c6d5b543ee1a841b6cb82598e8e7b58e0c2"
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
class OpenshiftCli < Formula
  desc "OpenShift command-line interface tools"
  homepage "https://www.openshift.com/"
  url "https://mirror.openshift.com/pub/openshift-v4/clients/ocp/4.13.6/openshift-client-src.tar.gz"
  sha256 "840fe08122f21ab8f8938e4b2be190ef2954568cd2735405185c3fa21eaed2c7"
  license "Apache-2.0"
  head "https://github.com/openshift/oc.git", shallow: false, branch: "master"

  livecheck do
    url "https://mirror.openshift.com/pub/openshift-v4/clients/ocp/stable/"
    regex(/href=.*?openshift-client-mac-(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "68875ae8a621b5a7b3d971f70af93a8fd662120af3fc707b35220cc011b909b4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5d05b40321abb49d22f94c75c756495e8dc65be2ee04b23c4c9abc66918fee83"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d37ca178ce114bce36045461e8126dd35c53e77830897ff70fe1ef2c0b47f239"
    sha256 cellar: :any_skip_relocation, ventura:        "051e440d1baae563409e67a44dfe615a3a5fb6c74370f8e7f97f639947a400dc"
    sha256 cellar: :any_skip_relocation, monterey:       "404efd6a133eccf4f397184c6d5a3e254785be6113fbe1ce709faee618435d29"
    sha256 cellar: :any_skip_relocation, big_sur:        "a6f8407ff6672ff84c87c88edcc2f5a78faf811468a8947f5e431f2a19dd0852"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b811bccd442359abf15733492319c09502772745c25615e45acaeb81d29f61ce"
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
    generate_completions_from_executable(bin/"oc", "completion", base_name: "oc")
  end

  test do
    # Grab version details from built client
    version_raw = shell_output("#{bin}/oc version --client --output=json")
    version_json = JSON.parse(version_raw)

    # Ensure that we had a clean build tree
    assert_equal "clean", version_json["clientVersion"]["gitTreeState"]

    if stable?
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

    end

    # Test that we can generate and write a kubeconfig
    (testpath/"kubeconfig").write ""
    system "KUBECONFIG=#{testpath}/kubeconfig #{bin}/oc config set-context foo 2>&1"
    assert_match "foo", shell_output("KUBECONFIG=#{testpath}/kubeconfig #{bin}/oc config get-contexts -o name")
  end
end
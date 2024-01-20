class OpenshiftCli < Formula
  desc "OpenShift command-line interface tools"
  homepage "https:www.openshift.com"
  url "https:mirror.openshift.compubopenshift-v4clientsocp4.14.8openshift-client-src.tar.gz"
  sha256 "8b98d46a18b7480cd488ba96df9f2732cc7f07255f153d614aa839b254274621"
  license "Apache-2.0"
  head "https:github.comopenshiftoc.git", shallow: false, branch: "master"

  livecheck do
    url "https:mirror.openshift.compubopenshift-v4clientsocpstable"
    regex(href=.*?openshift-client-mac-(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "339ee7e331341b5204febe2937949424670f05d8a3b203ee40e1137dbf1218bf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e15c3c946499a5a697782ab4d5bff2711817604ac34e29bd5f6b2b54e1e5ef16"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "618a7e482439bc5a514e8d2463f5e84bd140db1b0c8f34e79d385079d19b0a90"
    sha256 cellar: :any_skip_relocation, sonoma:         "c87adba844366ab7bb0265b2eb5d4943c435165c495c3c139ea64b3575fe026b"
    sha256 cellar: :any_skip_relocation, ventura:        "0a39eefdacd9e445d08c0ddfc29f3a3c9b19e5c9feb0f074e11e9d7fd555942f"
    sha256 cellar: :any_skip_relocation, monterey:       "c7ee27128cf69301614c521f202e25c19350d3d17f1a096c45488a91e9087354"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "baf6ca1f290f6a308bc291e1810e82eaa5cd3ce53358807171697d001f1ff1ce"
  end

  depends_on "go" => :build
  uses_from_macos "krb5"

  def install
    arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
    os = OS.kernel_name.downcase
    revision = build.head? ? Utils.git_head : Pathname.pwd.basename.to_s.delete_prefix("oc-")

    # See https:github.comHomebrewbrewissues14763
    ENV.O0 if OS.linux?

    system "make", "cross-build-#{os}-#{arch}", "OS_GIT_VERSION=#{version}", "SOURCE_GIT_COMMIT=#{revision}", "SHELL=binbash"
    bin.install "_outputbin#{os}_#{arch}oc"
    generate_completions_from_executable(bin"oc", "completion", base_name: "oc")
  end

  test do
    # Grab version details from built client
    version_raw = shell_output("#{bin}oc version --client --output=json")
    version_json = JSON.parse(version_raw)

    # Ensure that we had a clean build tree
    assert_equal "clean", version_json["clientVersion"]["gitTreeState"]

    if stable?
      # Verify the built artifact matches the formula
      assert_match version_json["clientVersion"]["gitVersion"], "v#{version}"

      # Get remote release details
      release_raw = shell_output("#{bin}oc adm release info #{version} --output=json")
      release_json = JSON.parse(release_raw)

      # Verify the formula matches the release data for the version
      assert_match version_json["clientVersion"]["gitCommit"],
        release_json["references"]["spec"]["tags"].find { |tag|
          tag["name"]=="cli"
        } ["annotations"]["io.openshift.build.commit.id"]

    end

    # Test that we can generate and write a kubeconfig
    (testpath"kubeconfig").write ""
    system "KUBECONFIG=#{testpath}kubeconfig #{bin}oc config set-context foo 2>&1"
    assert_match "foo", shell_output("KUBECONFIG=#{testpath}kubeconfig #{bin}oc config get-contexts -o name")
  end
end
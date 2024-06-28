class OpenshiftCli < Formula
  desc "OpenShift command-line interface tools"
  homepage "https:www.openshift.com"
  url "https:mirror.openshift.compubopenshift-v4clientsocp4.16.0openshift-client-src.tar.gz"
  sha256 "fc75e6240c6449854dc3afacce820671359d9d41032a6c52d428ad3c9880c5e0"
  license "Apache-2.0"
  head "https:github.comopenshiftoc.git", shallow: false, branch: "master"

  livecheck do
    url "https:mirror.openshift.compubopenshift-v4clientsocpstable"
    regex(href=.*?openshift-client-mac-(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b71a3354a058071461b2b39b77c2d2bd29d30933d546d266cc0112720e38d6df"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3f4064841685b91feb2a7c007226cfc128670851975fd6bb22436af18da8a468"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "974261cd9dc6daac89df705b299f34ea49e5c3c11d72e00a22bbf3a9ee2cce8b"
    sha256 cellar: :any_skip_relocation, sonoma:         "b74b090051cbd0df917e63a790ecc54945761a0b5f3e98790ac99ff8f60e03bf"
    sha256 cellar: :any_skip_relocation, ventura:        "892dec03b026dc15aa965a02a81719b9ee63ae6a647f14aa8995a62934844c77"
    sha256 cellar: :any_skip_relocation, monterey:       "967bb9be2dcb478201d7d1fd56206daf77ee2f0a8c48d54a9c5ae234022a5ce6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0a06872cee14280e105cba430dee2f7769ccbae1a50953fc39d8a57a1db154b4"
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
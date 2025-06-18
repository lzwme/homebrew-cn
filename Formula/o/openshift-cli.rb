class OpenshiftCli < Formula
  desc "OpenShift command-line interface tools"
  homepage "https:www.openshift.com"
  url "https:mirror.openshift.compubopenshift-v4clientsocp4.19.0openshift-client-src.tar.gz"
  # This project employs synchronized versioning so the sha256 may not change on version bumps
  sha256 "4819a705e344c9f908c10737d08bb639733690e6e15d35f49e5a37ef6baf4b80"
  license "Apache-2.0"
  head "https:github.comopenshiftoc.git", shallow: false, branch: "master"

  livecheck do
    url "https:mirror.openshift.compubopenshift-v4clientsocpstable"
    regex(href=.*?openshift-client-mac-(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2df501b8dcc0cc0d8976004caaf0ce5c9cc450541463f7ab7f75684ffafad460"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "82f49fcd98a156d3abfd786849b2b3f6cdb995b6d1122027ae3baeb461bd1156"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "52519fb20e92793762b8464214f89bfb33446eb6c1af17221c9e0df81bfb1759"
    sha256 cellar: :any_skip_relocation, sonoma:        "a25626fd4c69593c225f1367943ce89b682ec4018ad76b7cff2e52603ef00519"
    sha256 cellar: :any_skip_relocation, ventura:       "419bf9ad5e739d0428a8ae816e5fe830045fc9a0a2910e5372311e2b4f3583c0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ead6df049c94bb2b36c4d82601386261fa0f8527577d25221eb2535d4bd1cf14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6444266a2669f05517a49b1a10e01d03143b3bab4ad74b173396e7c7de4d9112"
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
    generate_completions_from_executable(bin"oc", "completion")
  end

  test do
    # Grab version details from built client
    version_raw = shell_output("#{bin}oc version --client --output=json")
    version_json = JSON.parse(version_raw)

    # Ensure that we had a clean build tree
    assert_equal "clean", version_json["clientVersion"]["gitTreeState"]

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

    # Test that we can generate and write a kubeconfig
    (testpath"kubeconfig").write ""
    system "KUBECONFIG=#{testpath}kubeconfig #{bin}oc config set-context foo 2>&1"
    assert_match "foo", shell_output("KUBECONFIG=#{testpath}kubeconfig #{bin}oc config get-contexts -o name")
  end
end
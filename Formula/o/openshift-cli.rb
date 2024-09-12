class OpenshiftCli < Formula
  desc "OpenShift command-line interface tools"
  homepage "https:www.openshift.com"
  url "https:mirror.openshift.compubopenshift-v4clientsocp4.16.10openshift-client-src.tar.gz"
  # This project employs synchronized versioning so the sha256 may not change on version bumps
  sha256 "1be74704436e803ab6932a96d0abd037319b2ea05f9706c7e33d9103af724d19"
  license "Apache-2.0"
  head "https:github.comopenshiftoc.git", shallow: false, branch: "master"

  livecheck do
    url "https:mirror.openshift.compubopenshift-v4clientsocpstable"
    regex(href=.*?openshift-client-mac-(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "21b15c1b946b3629cdd8da64d48185adeacd727ab831abc1b34596ec95da27e4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5db6998e5f7978beeec1ac474803f89dd891dd1ef77cfce63c9e6a19258d0b47"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f36f20b75c679efdb63c60351a7b9639cd24e39913649300ca4722a8c76c8cbc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4f858ddc1fe9e8976223f2823af41bdacfd177a68f8fe17404f2e6c2914b1812"
    sha256 cellar: :any_skip_relocation, sonoma:         "343f84a02f6e38386bde2eb3a9faecda761b34049491462cf19b897fbba64d7f"
    sha256 cellar: :any_skip_relocation, ventura:        "cd84330662499bf776db011ced1e73463d6d8c309b96aa185e8c2d5fd1e92164"
    sha256 cellar: :any_skip_relocation, monterey:       "5e91a710c84c40b5ed413bc80eb41678d0506fa6c871c4b5bead8ee27c23545a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ff82722df701ead80910f6a81d4e3fdeadf3cc292908d225a66a40a05c88bac"
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
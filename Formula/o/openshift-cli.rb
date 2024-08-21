class OpenshiftCli < Formula
  desc "OpenShift command-line interface tools"
  homepage "https:www.openshift.com"
  url "https:mirror.openshift.compubopenshift-v4clientsocp4.16.7openshift-client-src.tar.gz"
  sha256 "1be74704436e803ab6932a96d0abd037319b2ea05f9706c7e33d9103af724d19"
  license "Apache-2.0"
  head "https:github.comopenshiftoc.git", shallow: false, branch: "master"

  livecheck do
    url "https:mirror.openshift.compubopenshift-v4clientsocpstable"
    regex(href=.*?openshift-client-mac-(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "af02924669fcc5eb31b5df35d25ef46161682b255486e98f597c87cbb4751f89"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "38f9e1d1eda472102ad1f697a9a6daca9acf15e18d86022d09a77d6ed11a2d28"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f4534200fa0373b0d8d04017110322db58eb31f7ec2a14da22774862f31bb36a"
    sha256 cellar: :any_skip_relocation, sonoma:         "6a98cef18d66c762280c77408ffa63943b9ff11e343a301d9a35a61b6f22653a"
    sha256 cellar: :any_skip_relocation, ventura:        "6906cbe44150ccf705e9eb09f3afc65988f8da8298343534cda4c7d0a6dff052"
    sha256 cellar: :any_skip_relocation, monterey:       "b5fdad9638c1848c5fa00c678f338e677fdc108f346e4205daf6304dc2781569"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d201c73e9f90971d4f041b4c9802b5f102530e05027bcadbbfe0b819dccbc4ed"
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
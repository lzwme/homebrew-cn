class OpenshiftCli < Formula
  desc "OpenShift command-line interface tools"
  homepage "https:www.openshift.com"
  url "https:mirror.openshift.compubopenshift-v4clientsocp4.16.8openshift-client-src.tar.gz"
  # This project employs synchronized versioning so the sha256 may not change on version bumps
  sha256 "1be74704436e803ab6932a96d0abd037319b2ea05f9706c7e33d9103af724d19"
  license "Apache-2.0"
  head "https:github.comopenshiftoc.git", shallow: false, branch: "master"

  livecheck do
    url "https:mirror.openshift.compubopenshift-v4clientsocpstable"
    regex(href=.*?openshift-client-mac-(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "52916393b9b38106c60b2f31fe1f17fca569e5e1f43fe80ebde2c38bd937fb3f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fba96a5d6290e4f7ff659cea851ee4e3f684189f5d087f261bf0693255eb6306"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "617e5cfd96fff1c565a45f6d68de1ccc4fde0dfa2e46a0434de35d802540c868"
    sha256 cellar: :any_skip_relocation, sonoma:         "fb80bcc8275e74812cba64fdb9505572261c66d2e61c4b7ad3bf3957fa4cac15"
    sha256 cellar: :any_skip_relocation, ventura:        "dab6aef5452571f9ceca3fed45c5eab4960734061b2ee82dfaeac931e3b71943"
    sha256 cellar: :any_skip_relocation, monterey:       "7a2cc16b6c293abbebdfe3b8145ff95fdafa810a14d729372200797561129a7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba369ea2fc0950781178c91d1ecf7175ff2208a0dc9e8a1634a23f6d6d170ca9"
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
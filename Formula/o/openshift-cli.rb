class OpenshiftCli < Formula
  desc "OpenShift command-line interface tools"
  homepage "https:www.openshift.com"
  url "https:mirror.openshift.compubopenshift-v4clientsocp4.17.9openshift-client-src.tar.gz"
  # This project employs synchronized versioning so the sha256 may not change on version bumps
  sha256 "0695fcf3e514f6dcc5b86222ed067942f5e604ce27eff15a12f4a9713481a051"
  license "Apache-2.0"
  head "https:github.comopenshiftoc.git", shallow: false, branch: "master"

  livecheck do
    url "https:mirror.openshift.compubopenshift-v4clientsocpstable"
    regex(href=.*?openshift-client-mac-(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1213ac711eea9b5ec3b5b1f4159d58ce88126e8ed4af2653e3ad828a7d5b5ad4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8216d30a5d722dc823b072cdb41880cf72f048e6634eff1deece38860d605b01"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8655853dcd9e3edfc6dbc312bf2c0c05fcf40ef0c82f87349f3544f923fd9e56"
    sha256 cellar: :any_skip_relocation, sonoma:        "ef298b9da1005621f2bdb06b4b2aed2be6bf9ed4d538b4197fddd14687a92acc"
    sha256 cellar: :any_skip_relocation, ventura:       "8e77813bce091fec617d864e4d0a7570600c3633597e4d1fb8ca4366f1722f6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c582dbddfe6f4cfdf4133ad6f502bc75f8d8d307e63743fa5d83ede7c4f3b42d"
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
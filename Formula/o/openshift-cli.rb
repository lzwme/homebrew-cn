class OpenshiftCli < Formula
  desc "OpenShift command-line interface tools"
  homepage "https:www.openshift.com"
  url "https:mirror.openshift.compubopenshift-v4clientsocp4.15.6openshift-client-src.tar.gz"
  sha256 "485619d379e41e6d0ae65c1b0c7f90d3764730e0a87e5685da761d76106d25c4"
  license "Apache-2.0"
  head "https:github.comopenshiftoc.git", shallow: false, branch: "master"

  livecheck do
    url "https:mirror.openshift.compubopenshift-v4clientsocpstable"
    regex(href=.*?openshift-client-mac-(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f826550e454fae19228da10ae44ba5f86c5deaf7f00ed04b1c7170c62466160b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9826366ba4aaadfbd4ea1c69e4d238dc8bdc6f678bd3e9ac01afafed48493555"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bc7eb12c2fb73b17febe1f83cbda3025abf40066489a1582860ee002ecba9bd0"
    sha256 cellar: :any_skip_relocation, sonoma:         "be41bc35022570513516c237b4292ef25fe6ade6d20be0dcdb1dde5fac6765f3"
    sha256 cellar: :any_skip_relocation, ventura:        "654e7985535b062afefe4fc0ecd0e075700420f9ad0b445855b2ece16e468b2c"
    sha256 cellar: :any_skip_relocation, monterey:       "8df0c892a0add45975783133430b04a92e9d0450525f46850790391460168813"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5e2d7ff5a7d4738030d514156894132e40ff6627a71e87aa9f6099597075f4ef"
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
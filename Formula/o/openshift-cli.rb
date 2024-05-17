class OpenshiftCli < Formula
  desc "OpenShift command-line interface tools"
  homepage "https:www.openshift.com"
  url "https:mirror.openshift.compubopenshift-v4clientsocp4.15.12openshift-client-src.tar.gz"
  sha256 "0368c5c50a524b5a959d0a94a119eb441ead98252ec2e9df6cb79ad983607631"
  license "Apache-2.0"
  head "https:github.comopenshiftoc.git", shallow: false, branch: "master"

  livecheck do
    url "https:mirror.openshift.compubopenshift-v4clientsocpstable"
    regex(href=.*?openshift-client-mac-(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "15649de620977bea0b218eb9b984e1aadda70b20fc0a222faae999e71fb470fd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3b290f7c9c2bfa19588d6aefd1a39e99f59304b864a62fd669b86772df5de7ce"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2c6866a0dc46133c237b221f7b8fb797bff5352a9ceef8e994d27ab5a71c7310"
    sha256 cellar: :any_skip_relocation, sonoma:         "532dabcec7cae66e92f01544c0bcc40383712f799af0e6929cc7ee31840f040f"
    sha256 cellar: :any_skip_relocation, ventura:        "dcb3537804268970e4b23030469e9dc8d482e73847db6df8279f6f395333f84f"
    sha256 cellar: :any_skip_relocation, monterey:       "790477ad67e5d79a316f9ff9e723abcb4796403da427bbd29c76f1584cfb12f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fcf63cff67234bd871fa5768fd1ebd4ab927a98ac80857db914ac2123acf714a"
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
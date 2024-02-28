class OpenshiftCli < Formula
  desc "OpenShift command-line interface tools"
  homepage "https:www.openshift.com"
  url "https:mirror.openshift.compubopenshift-v4clientsocp4.14.13openshift-client-src.tar.gz"
  sha256 "a2dcdbc17ef649e3fb52b0e51943bc60adfdb126c46b18a8649f768a40afe00d"
  license "Apache-2.0"
  head "https:github.comopenshiftoc.git", shallow: false, branch: "master"

  livecheck do
    url "https:mirror.openshift.compubopenshift-v4clientsocpstable"
    regex(href=.*?openshift-client-mac-(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4ec26b73bbe3b9d7c988389b1b3ac544cd3e8cca0e4ea2081029264b6aaedd12"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "137e00e0baa77ff9c7efdd8579cbf067e14c0bb00ad00ea318dd59c7d4db238e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "68966c759ae800ce8d934e26107ed6811001b83a491dca248cd32c07d6b47f5e"
    sha256 cellar: :any_skip_relocation, sonoma:         "a1be75fbb8ee50d1388608510e03a2b28df338203067253659b77913259b0bdf"
    sha256 cellar: :any_skip_relocation, ventura:        "9fe3eb55460866341bd2e27bf8f5500b0a06b244049a5efcafff2b044332827a"
    sha256 cellar: :any_skip_relocation, monterey:       "2e1ff713925d5de66ccf172d58172a73d804db23c7771f73be10069ea3e5bceb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3527cd74547930937ddeded5adc87691eb352810e6242c6b6e82c044c79e1fe7"
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
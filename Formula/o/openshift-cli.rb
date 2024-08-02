class OpenshiftCli < Formula
  desc "OpenShift command-line interface tools"
  homepage "https:www.openshift.com"
  url "https:mirror.openshift.compubopenshift-v4clientsocp4.16.4openshift-client-src.tar.gz"
  sha256 "84a1c8beac23c00821bd81c31dc561b493c74eb0e520f3cec723a2cd735b4368"
  license "Apache-2.0"
  head "https:github.comopenshiftoc.git", shallow: false, branch: "master"

  livecheck do
    url "https:mirror.openshift.compubopenshift-v4clientsocpstable"
    regex(href=.*?openshift-client-mac-(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c695c8ba6c40ab5af51e2c23bd1aef89d3e34bc8c7bab92f76019d15303c646f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9bd763f3f78f456e27aac5fdb208eb7e8430b6b65dbe8c75d7c63878ad498caf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fc4eb8749a4a06777b4539bbf96f0cf26c4cdf848cc62ef4e0c17c29219a26b6"
    sha256 cellar: :any_skip_relocation, sonoma:         "8f5213d74508578f4fec8088dfc1a94a4ab0fd95b27271522cff2eac642f91b3"
    sha256 cellar: :any_skip_relocation, ventura:        "8a4fae65fbf91472894358225d73337b5bdf08ca68b2836c8daabae6de60fc10"
    sha256 cellar: :any_skip_relocation, monterey:       "9427a3b6341b2e3ef1c0379fd1070ea7ac74dbf1acc3a7b0c0cc347030c5be48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b4c8fa6959607e9b1060d9ac6e6748b81969c4558284826aa58fb77a54319a84"
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
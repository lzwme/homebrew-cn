class OpenshiftCli < Formula
  desc "OpenShift command-line interface tools"
  homepage "https:www.openshift.com"
  url "https:mirror.openshift.compubopenshift-v4clientsocp4.16.2openshift-client-src.tar.gz"
  sha256 "96d11694e9772e8fdf988a8ca4b7585065c48183d99ea033fadebcfb5de9db22"
  license "Apache-2.0"
  head "https:github.comopenshiftoc.git", shallow: false, branch: "master"

  livecheck do
    url "https:mirror.openshift.compubopenshift-v4clientsocpstable"
    regex(href=.*?openshift-client-mac-(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "19296c45d9a4eddd42d039316c0fee5eb45e22618786b01cbc7d6068d893e80f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d0b3f58ca545846d7a40d9111769fbf2f77f77c456dfff5f5d500f80e98f692a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "657c420c021ad8b17da365a71cf415b5c6c0f953ee74e432a629a83650f5a562"
    sha256 cellar: :any_skip_relocation, sonoma:         "34bfaaa84a189666a4eb6acab6eb316d7f53ad4de47610c1c8863c6c518fd27b"
    sha256 cellar: :any_skip_relocation, ventura:        "9887d8844dad69bba28316a1dad6e0e6da89e4ed6a0021711f73d0d460abc7ef"
    sha256 cellar: :any_skip_relocation, monterey:       "af9987df560345f17f76e4a05018c41c4f9048fe810701535fad021a9b91ce9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "54d474437962f92d79e2f3b13013feae6c46d2b2af6c1a3ff844e23dc9d13891"
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
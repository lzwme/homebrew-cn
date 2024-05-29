class OpenshiftCli < Formula
  desc "OpenShift command-line interface tools"
  homepage "https:www.openshift.com"
  url "https:mirror.openshift.compubopenshift-v4clientsocp4.15.14openshift-client-src.tar.gz"
  sha256 "a7ecc96a0f70020d0b02a7c408cf11b30e63bc6a4cd37dae747f5675532ffa08"
  license "Apache-2.0"
  head "https:github.comopenshiftoc.git", shallow: false, branch: "master"

  livecheck do
    url "https:mirror.openshift.compubopenshift-v4clientsocpstable"
    regex(href=.*?openshift-client-mac-(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "eeff5f92a4f2b0b101f7e435393628710cbb18c8eef8e1fa03a928cdbb7a1576"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "654c4149eb3ed15dc5898afeac348c5ee7135cd3cc2437d7e30097a5acdbd97d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b2a9739c154ff6b38b989135602f5cb1dc603526453fd69e5e6966de395a03ca"
    sha256 cellar: :any_skip_relocation, sonoma:         "d4330800146203b26668c09c9a8f1192ad5cfef8b68125e17f63b5e8bcda320e"
    sha256 cellar: :any_skip_relocation, ventura:        "dc3f8c314b83cea2c10772bf4fe6a5b8fbea2e999e2677714be5afffb7c78ac0"
    sha256 cellar: :any_skip_relocation, monterey:       "ea555a3fcce5e95a7048b8d9c1fb99567a65dadb1838c81c3a3236452f62ea17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c4f6b8b846662b471335f5c6cb077fa3fadd79ffa19d9575339eca49af6351f8"
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
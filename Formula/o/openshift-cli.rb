class OpenshiftCli < Formula
  desc "OpenShift command-line interface tools"
  homepage "https://www.openshift.com/"
  url "https://mirror.openshift.com/pub/openshift-v4/clients/ocp/4.14.0/openshift-client-src.tar.gz"
  sha256 "8200c6bf263ecc790594933f194da4ad9c26a57acc4b2f2d2948db7b149bb90a"
  license "Apache-2.0"
  head "https://github.com/openshift/oc.git", shallow: false, branch: "master"

  livecheck do
    url "https://mirror.openshift.com/pub/openshift-v4/clients/ocp/stable/"
    regex(/href=.*?openshift-client-mac-(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d4a515c23dabaf651e0b2ad3f8a9dac55564b69810a394b6ce3ac89356a4e849"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "438384a4cf6f06e5b2718aa2aa71e29e2723598f65eddf6dd844d9ae30e89e77"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5f62b3dcc8f9e98905fd7f80f8f29d423d2342efb66a259ad182956b77723e99"
    sha256 cellar: :any_skip_relocation, sonoma:         "41d5a2145cd6dcf23f4598114a4e92e5461640ac2ed42cd828235b1895be0463"
    sha256 cellar: :any_skip_relocation, ventura:        "d9993f58bc754ff6d4b950847fa97ee3bd16de8922c11f6ec214bbf5fa8ae26a"
    sha256 cellar: :any_skip_relocation, monterey:       "9fe1bd4d9a2fb447cdc036949be6f86d894cd661f16fd87e6c05db6bea0ad75d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d6aa2e7d7ac7bbadce37141de5f6b61921527feaa423bcc00ae11b666abab10e"
  end

  depends_on "go" => :build
  uses_from_macos "krb5"

  def install
    arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
    os = OS.kernel_name.downcase
    revision = build.head? ? Utils.git_head : Pathname.pwd.basename.to_s.delete_prefix("oc-")

    # See https://github.com/Homebrew/brew/issues/14763
    ENV.O0 if OS.linux?

    system "make", "cross-build-#{os}-#{arch}", "OS_GIT_VERSION=#{version}", "SOURCE_GIT_COMMIT=#{revision}", "SHELL=/bin/bash"
    bin.install "_output/bin/#{os}_#{arch}/oc"
    generate_completions_from_executable(bin/"oc", "completion", base_name: "oc")
  end

  test do
    # Grab version details from built client
    version_raw = shell_output("#{bin}/oc version --client --output=json")
    version_json = JSON.parse(version_raw)

    # Ensure that we had a clean build tree
    assert_equal "clean", version_json["clientVersion"]["gitTreeState"]

    if stable?
      # Verify the built artifact matches the formula
      assert_match version_json["clientVersion"]["gitVersion"], "v#{version}"

      # Get remote release details
      release_raw = shell_output("#{bin}/oc adm release info #{version} --output=json")
      release_json = JSON.parse(release_raw)

      # Verify the formula matches the release data for the version
      assert_match version_json["clientVersion"]["gitCommit"],
        release_json["references"]["spec"]["tags"].find { |tag|
          tag["name"]=="cli"
        } ["annotations"]["io.openshift.build.commit.id"]

    end

    # Test that we can generate and write a kubeconfig
    (testpath/"kubeconfig").write ""
    system "KUBECONFIG=#{testpath}/kubeconfig #{bin}/oc config set-context foo 2>&1"
    assert_match "foo", shell_output("KUBECONFIG=#{testpath}/kubeconfig #{bin}/oc config get-contexts -o name")
  end
end
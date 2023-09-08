class OpenshiftCli < Formula
  desc "OpenShift command-line interface tools"
  homepage "https://www.openshift.com/"
  url "https://mirror.openshift.com/pub/openshift-v4/clients/ocp/4.13.10/openshift-client-src.tar.gz"
  sha256 "6b6ac6109dbbc8240a343d4a07661cf98ae008305bf432b58ca6b9c00c5a83d5"
  license "Apache-2.0"
  head "https://github.com/openshift/oc.git", shallow: false, branch: "master"

  livecheck do
    url "https://mirror.openshift.com/pub/openshift-v4/clients/ocp/stable/"
    regex(/href=.*?openshift-client-mac-(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "85bec9ab4efb9d2479a30777bb6f8af2ca14b4f9d11763ce31b8176da10175bf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e858d92f3a4a4676d6c7b8c3d1601a4d2a2e2b56c8229705717973406312560d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1a9aa83069b57a896c78558712ffe57ec777be69a19b8e47a6bb1c1612869ac4"
    sha256 cellar: :any_skip_relocation, ventura:        "e57e59c8733d40cf80857f4a4a64d430f214941d541972261b7b4bb75e144f07"
    sha256 cellar: :any_skip_relocation, monterey:       "2edc6167a98059c0a635c279773fc2d13b4e6709434520c714de8304c444cd28"
    sha256 cellar: :any_skip_relocation, big_sur:        "82848b1c74fff927a634a716a69fe4a43671d7f4034318ed4f909de625e404cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0071b893378e63fa6ff68e04fb05c77a4f1bef0888e505e39bdfa6727422ab69"
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
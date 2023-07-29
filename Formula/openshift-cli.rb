class OpenshiftCli < Formula
  desc "OpenShift command-line interface tools"
  homepage "https://www.openshift.com/"
  url "https://mirror.openshift.com/pub/openshift-v4/clients/ocp/4.13.5/openshift-client-src.tar.gz"
  sha256 "a3c0be9664c9cc4239c9bca20cf67a369c02224fe7d7f8177c9d67ed230599da"
  license "Apache-2.0"
  head "https://github.com/openshift/oc.git", shallow: false, branch: "master"

  livecheck do
    url "https://mirror.openshift.com/pub/openshift-v4/clients/ocp/stable/"
    regex(/href=.*?openshift-client-mac-(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d182390f0977b1ededae46a421e5888cf8374ffb621bfc96af0fdd99ff011336"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7b1e2c148e866a622cb3ae846b54e6b7a7a10a8887f7332590dd0c7ba0430f5a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e314787ecac1b0922c149f211f1e8c08ef73999d3f0dfbad35816e2ae609ebae"
    sha256 cellar: :any_skip_relocation, ventura:        "f58fc125419ee638c03cdbb8333e391f89fe4c256747462d09266a0011dd0160"
    sha256 cellar: :any_skip_relocation, monterey:       "88062669efdbda446455da3b97189c1a7477b35ad619617515a99d1f761d3896"
    sha256 cellar: :any_skip_relocation, big_sur:        "a48e6b6ba2ea3a58bd3ef8458c5c061937bfe5aab242fe90ea04d51df0d2f26f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "21d67519bd737c992ac1a096f6c0744f367d314e98f5f0708b9395042679a470"
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
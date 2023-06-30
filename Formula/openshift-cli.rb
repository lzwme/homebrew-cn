class OpenshiftCli < Formula
  desc "OpenShift command-line interface tools"
  homepage "https://www.openshift.com/"
  url "https://mirror.openshift.com/pub/openshift-v4/clients/ocp/4.13.4/openshift-client-src.tar.gz"
  sha256 "3a1431859b3261f8a53dcf3be861520dc19d61c93bcea482bff5364d4f594211"
  license "Apache-2.0"
  head "https://github.com/openshift/oc.git", shallow: false, branch: "master"

  livecheck do
    url "https://mirror.openshift.com/pub/openshift-v4/clients/ocp/stable/"
    regex(/href=.*?openshift-client-mac-(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6a6bd3371f84e9b7b844800ae6d5b8a89df5dfc5652bef5650a5ccf396796ff8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "42fabb2962d47fb7091f6ae49e8c729667ae832fa8db9859579a1252b67f577d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4a91cfc9adbdd818378448ffd7c0671948e762246b64b0f2fcae254516ee6732"
    sha256 cellar: :any_skip_relocation, ventura:        "bfbbad5ff53e2c7baebbd5a3681bf582b550b601be8c4be8da1a159ee5653a83"
    sha256 cellar: :any_skip_relocation, monterey:       "00cfccec8de68ee9311a999b1c631286a2d5889d404bebf4eafbe67966bf29ee"
    sha256 cellar: :any_skip_relocation, big_sur:        "847f1eb1b9ef1548f2e2b28a04c9dbd35652aa3d5c25c3d49a170e3e3ba4c3b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3991a288b08a2804661ab0a76aa7b2a63ec80ce08c2ad34731fb393e57cea8bb"
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
class OpenshiftCli < Formula
  desc "OpenShift command-line interface tools"
  homepage "https:www.openshift.com"
  url "https:mirror.openshift.compubopenshift-v4clientsocp4.16.5openshift-client-src.tar.gz"
  sha256 "c0a3da890c60359c9666505cca29c17470800bb0fc6faf02de106de7dc4ca657"
  license "Apache-2.0"
  head "https:github.comopenshiftoc.git", shallow: false, branch: "master"

  livecheck do
    url "https:mirror.openshift.compubopenshift-v4clientsocpstable"
    regex(href=.*?openshift-client-mac-(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1a5a91ff82f5306e27f12ad4a893e1c2319dd806a7dda1a0fad2901a3d960a10"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "389f8d81d35869b3276463a009e462d84646d58ce2cc76fc51b720b5c33539ce"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3b32d3fb9f8f729a00540a390443314a0fba3ab29c35734a40b3099bc89e2a46"
    sha256 cellar: :any_skip_relocation, sonoma:         "5fd4afa87969cd7007bea3e61f40da7cc1d2937e8c73c85384eb234a7ddb29d7"
    sha256 cellar: :any_skip_relocation, ventura:        "9be55cb6260aff06987679a836ad6f296e2ae058330f76df20f2d11e1f2180ff"
    sha256 cellar: :any_skip_relocation, monterey:       "68f6aa2de7376d18f19f9b86db77566ecf9e745f1d4b84ba40871e1b9ea8d756"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4aaf148aa036a451f3fa25d23e991e57b7a2da0ff2bb65145b5d5b1ce2bba7cf"
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
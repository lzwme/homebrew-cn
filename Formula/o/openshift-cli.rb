class OpenshiftCli < Formula
  desc "OpenShift command-line interface tools"
  homepage "https:www.openshift.com"
  url "https:mirror.openshift.compubopenshift-v4clientsocp4.15.18openshift-client-src.tar.gz"
  sha256 "bf96927eea9cd23d4243239e74d9324c7da1cbf45b8adf4559a440d7804b865d"
  license "Apache-2.0"
  head "https:github.comopenshiftoc.git", shallow: false, branch: "master"

  livecheck do
    url "https:mirror.openshift.compubopenshift-v4clientsocpstable"
    regex(href=.*?openshift-client-mac-(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "13342445649edb6238c8b2dfd373e83bb1634eb8774e789b1673955382d616cb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d147bb97fc76af4ace45c1ceb5c0150b65ad4cfdb300d371024e55d6fd294d6a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a3c1281b74f6465b93c78d559176ace369cf27de5b7c8c0320e6b160e84cf138"
    sha256 cellar: :any_skip_relocation, sonoma:         "1f93bcf9005e11f4b8432c8ff5b80043cb7cd73049fe4ffacf5c2aef64929f46"
    sha256 cellar: :any_skip_relocation, ventura:        "42c1a332f9f98f4f753a805801cde997141f9baf3376057db5fa83480153e364"
    sha256 cellar: :any_skip_relocation, monterey:       "9027c9963dee484455a1066f57131ff725cf9ffb46742d8b7e02cd7bfeff3dcd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e1b300d0a3f31b4895016f07c929ed623e676fe73b9d4def420c17243b7ce22"
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
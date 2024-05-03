class OpenshiftCli < Formula
  desc "OpenShift command-line interface tools"
  homepage "https:www.openshift.com"
  url "https:mirror.openshift.compubopenshift-v4clientsocp4.15.10openshift-client-src.tar.gz"
  sha256 "485619d379e41e6d0ae65c1b0c7f90d3764730e0a87e5685da761d76106d25c4"
  license "Apache-2.0"
  head "https:github.comopenshiftoc.git", shallow: false, branch: "master"

  livecheck do
    url "https:mirror.openshift.compubopenshift-v4clientsocpstable"
    regex(href=.*?openshift-client-mac-(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "34f6630b5a63604d5908f37de9d0dc5c6e83a8ad8cfa3f085f7601f143902f51"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "59f95d3e0f37fda3b9a59bd108aeb8ed3217a8cad1c6ff5f93520f3bbfb026e6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9300869063112f493eab06ba2b8c8892f0f049b68046fed4e84e3ecf8ed2f570"
    sha256 cellar: :any_skip_relocation, sonoma:         "f7d977cd82590b27bf93381b24a63d26e6ec1b306f5526da386fdd751b1a8368"
    sha256 cellar: :any_skip_relocation, ventura:        "6b61ea785591886c05b53516aaf9291666391ecd4be65fa5786068d00905c530"
    sha256 cellar: :any_skip_relocation, monterey:       "b0c2f356a224c619dd046f3b0ad58fcbec72aaa5f2dcfd44282a2cd3f508e868"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2993fdbf7aa8748b76ea186601bdac2f498c0d7cadd2a1a59edff9ff25ccf149"
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
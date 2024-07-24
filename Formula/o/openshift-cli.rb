class OpenshiftCli < Formula
  desc "OpenShift command-line interface tools"
  homepage "https:www.openshift.com"
  url "https:mirror.openshift.compubopenshift-v4clientsocp4.16.3openshift-client-src.tar.gz"
  sha256 "68fcb40ed93907be6e548bae54ed1c87983e3fac76833ccb0ccf66830700dbfd"
  license "Apache-2.0"
  head "https:github.comopenshiftoc.git", shallow: false, branch: "master"

  livecheck do
    url "https:mirror.openshift.compubopenshift-v4clientsocpstable"
    regex(href=.*?openshift-client-mac-(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bc1cd38c2d779be064478ad1717bee330cc866590f4ddb2169ae9c16556340bd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a2855de1ccaa71d25b713d4ff7ca1c1ea2d256e62a4d26de06505d32f9c74224"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b89607f58da231e985f7d9d4d7dfa102941da2c64ae1203031c3257d4716d71a"
    sha256 cellar: :any_skip_relocation, sonoma:         "df401b40b29733a8b6837203be4e69e16c2b485c72bbad9825d986a793fa2398"
    sha256 cellar: :any_skip_relocation, ventura:        "23ad264534c8b757b789da1e8a5b3771399be4e75cadbf83c4ba538ac90fbbb3"
    sha256 cellar: :any_skip_relocation, monterey:       "261398a9011e0f48d0986502c69c27f7bdb22504d097e98640e346b509af94cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e1ee0fd52dc4637e1fe016e446fad3814413fd496dd0eea0545985128d244a61"
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
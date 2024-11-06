class OpenshiftCli < Formula
  desc "OpenShift command-line interface tools"
  homepage "https:www.openshift.com"
  url "https:mirror.openshift.compubopenshift-v4clientsocp4.17.3openshift-client-src.tar.gz"
  # This project employs synchronized versioning so the sha256 may not change on version bumps
  sha256 "87ac88470f92bc01d4a225b7d5bea8d96920806bdc9fba2b2c3fcfaa31a78e5b"
  license "Apache-2.0"
  head "https:github.comopenshiftoc.git", shallow: false, branch: "master"

  livecheck do
    url "https:mirror.openshift.compubopenshift-v4clientsocpstable"
    regex(href=.*?openshift-client-mac-(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b8ff7a481526f7b4900218ccec55b75ac0aba4d5f000713748fd63b84fc0d614"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ad16f029e62cde6eb245e31d312b3d2e7b3b07f20d79d0bd09cb5abc1c700c51"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4136246ccb03a922f81b5e43cc6e25c71568fd8f5485c7ec8f16da7e48142364"
    sha256 cellar: :any_skip_relocation, sonoma:        "5b891929a6a29f5004864272257bad9cba4f4d7e5f4bb37ff9156d8ffcd48eca"
    sha256 cellar: :any_skip_relocation, ventura:       "001171be0d714036930bc76066333abefaa8ca6479adfa6c3a6a970246c58e95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a2d7e08d3edd53cd55a3ff75f455052902b48f1d530a9d0834fc2ec8220421c4"
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

    # Test that we can generate and write a kubeconfig
    (testpath"kubeconfig").write ""
    system "KUBECONFIG=#{testpath}kubeconfig #{bin}oc config set-context foo 2>&1"
    assert_match "foo", shell_output("KUBECONFIG=#{testpath}kubeconfig #{bin}oc config get-contexts -o name")
  end
end
class OpenshiftCli < Formula
  desc "OpenShift command-line interface tools"
  homepage "https:www.openshift.com"
  url "https:mirror.openshift.compubopenshift-v4clientsocp4.17.10openshift-client-src.tar.gz"
  # This project employs synchronized versioning so the sha256 may not change on version bumps
  sha256 "0695fcf3e514f6dcc5b86222ed067942f5e604ce27eff15a12f4a9713481a051"
  license "Apache-2.0"
  head "https:github.comopenshiftoc.git", shallow: false, branch: "master"

  livecheck do
    url "https:mirror.openshift.compubopenshift-v4clientsocpstable"
    regex(href=.*?openshift-client-mac-(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "62797b1f3945e74abf8970888e59c6c9548a7e1c3507004beab3a2c597c1981a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "44ca1c1f6228fa957b6f826221b47497942a04df47f4f0fbb4f03ad1ccaafa65"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d556639d0046e2fc5b8e988e14264c15298b07f8696630bb9fe46791fc225bfc"
    sha256 cellar: :any_skip_relocation, sonoma:        "d4458d1ae8c094ee9a6b5fdcbbc1d2f9253868ebc7964b65963390eeb1fe1522"
    sha256 cellar: :any_skip_relocation, ventura:       "c3aa4aa28db6eb9b15ef149b656e2c1d7b5837ded3513676b0f67d6245a091cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "73db8a3a9c253bc85f20fcf37246a17dce9e5d3ca81dd6b68e8a96f35aac2dba"
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
    generate_completions_from_executable(bin"oc", "completion")
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
class OpenshiftCli < Formula
  desc "OpenShift command-line interface tools"
  homepage "https:www.openshift.com"
  url "https:mirror.openshift.compubopenshift-v4clientsocp4.18.13openshift-client-src.tar.gz"
  # This project employs synchronized versioning so the sha256 may not change on version bumps
  sha256 "fcbf4750ecb1131f61b9efd20f82fb5df3b4ff965d8ae68acb2a9b0c4ff380c7"
  license "Apache-2.0"
  head "https:github.comopenshiftoc.git", shallow: false, branch: "master"

  livecheck do
    url "https:mirror.openshift.compubopenshift-v4clientsocpstable"
    regex(href=.*?openshift-client-mac-(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "00aedfa70677e0693d0e41502b0156334234d8e6ab516d58d5d75bce675f7f01"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f2d6549116b0d51b9d27f7816fe3960c49d6e1016fefeaa7003d3f05b69826ef"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dc2289eb069fa9cf1d91ed8efc42ecab79b1cb1d305530e7b76dbe7151a74bf8"
    sha256 cellar: :any_skip_relocation, sonoma:        "1b843be4ebf5c82316af0b18f6876b712647e169914d65842947c3b21ec54aeb"
    sha256 cellar: :any_skip_relocation, ventura:       "7c61ad59463f0b677c641e3daf4b6a4291f04a5b1a1d177303a55e3fb4602893"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cf272bab88d25d3787ca26b92ae620bc7ece1e44ce0230e11f9a584dff6da33a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b3824ca645b78c38797cbe866829a82fffe556735357667b4b4cacf7afed3202"
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
class OpenshiftCli < Formula
  desc "OpenShift command-line interface tools"
  homepage "https:www.openshift.com"
  url "https:mirror.openshift.compubopenshift-v4clientsocp4.17.8openshift-client-src.tar.gz"
  # This project employs synchronized versioning so the sha256 may not change on version bumps
  sha256 "e8d75a0847cf43cf9a6ebf3dc0d1cfc4aa8920ffdf190730588e8c2e3cdffcc3"
  license "Apache-2.0"
  head "https:github.comopenshiftoc.git", shallow: false, branch: "master"

  livecheck do
    url "https:mirror.openshift.compubopenshift-v4clientsocpstable"
    regex(href=.*?openshift-client-mac-(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "df987aadaa0dbd7a9105d97ef29f93649acd70e2910bea203b31392ce2ce23b0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b6eeb301e9208322059b0183413639b8785a7504be3d67c92958e1dbbfd3e3af"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d9c3ed92d60660843c370a8aaaf0456f5b632047c85c528bdb9abfd607011a95"
    sha256 cellar: :any_skip_relocation, sonoma:        "b116415a6cfcb50511f653bd5cc93abd691b3d8e13a7c56a1bbef06d722422d3"
    sha256 cellar: :any_skip_relocation, ventura:       "8670d4e6562ad1a3db44dcade5f14c1fb4bbb25828eacdf80f7ac09eaf6db167"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "da7e211bb7a61be7ff078d640c72a717542e326287453793b541e9c8ed1d40bd"
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
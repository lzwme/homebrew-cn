class OpenshiftCli < Formula
  desc "OpenShift command-line interface tools"
  homepage "https:www.openshift.com"
  url "https:mirror.openshift.compubopenshift-v4clientsocp4.17.5openshift-client-src.tar.gz"
  # This project employs synchronized versioning so the sha256 may not change on version bumps
  sha256 "e4599f768c1e937755271a4da806589b2bae49807de5df4e4ea8ba64c8256c4f"
  license "Apache-2.0"
  head "https:github.comopenshiftoc.git", shallow: false, branch: "master"

  livecheck do
    url "https:mirror.openshift.compubopenshift-v4clientsocpstable"
    regex(href=.*?openshift-client-mac-(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f92a2c0ef9c220d42dc9f70f634b29499329f700ca642ccfc8903161f7c2cbd1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "19c15716770c642cd3c7c97457b0b24e5929e6a23a7ef3db5ef7070b363e4b5b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7ea60331e3827273cc8f05529f5ef9902a0fdcefab71308d20b68f1221cfc8b6"
    sha256 cellar: :any_skip_relocation, sonoma:        "a3d706ab2d6c27e58bc9d9a1b7b656974868fe5c000bbf5cf70db06d32dac9ab"
    sha256 cellar: :any_skip_relocation, ventura:       "0eabcfad0ded60ffcdb21cb277a15147556a9189d0e5f8e5783d7a8deec36fc2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ba0eec3b651fbd99548ca1013d6c36bfb95afc3ea85429d1229171117f5afcda"
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
class OpenshiftCli < Formula
  desc "OpenShift command-line interface tools"
  homepage "https://www.openshift.com/"
  url "https://mirror.openshift.com/pub/openshift-v4/clients/ocp/4.19.1/openshift-client-src.tar.gz"
  # This project employs synchronized versioning so the sha256 may not change on version bumps
  sha256 "a0626502ac41fa0d76e37990253b5b6c515847b272e496ca288ac360bace6581"
  license "Apache-2.0"
  head "https://github.com/openshift/oc.git", shallow: false, branch: "master"

  livecheck do
    url "https://mirror.openshift.com/pub/openshift-v4/clients/ocp/stable/"
    regex(/href=.*?openshift-client-mac-(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eab995fa1c56cf64b011e043f42804ddd20791bc1e6670723d0819318489014c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "587ec6ad6259ef09fc00d0f7db1ee818b2e3c16c286f8b2c70c469c791d1d78b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f460e2182f47b512cf1044f83b268c1107553b2a5f52da5157ac4b172bfb54ff"
    sha256 cellar: :any_skip_relocation, sonoma:        "241b74407064fdc06e8fb9369fac8307a1ac7a921a4d440a93b1552d2b846401"
    sha256 cellar: :any_skip_relocation, ventura:       "d1fbc2e58dba66b361c5280d93242ae5dd5de104f20995e8dfed1379fc36ffaf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8f527ee9edcc109e196697365a17088e72e2d082a9c581e26c8862963ea5b22c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5d9c4de586012a350727547fe25d2060ed298c1e2deed696d4c6a1389b8ceb1b"
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
    generate_completions_from_executable(bin/"oc", "completion")
  end

  test do
    # Grab version details from built client
    version_raw = shell_output("#{bin}/oc version --client --output=json")
    version_json = JSON.parse(version_raw)

    # Ensure that we had a clean build tree
    assert_equal "clean", version_json["clientVersion"]["gitTreeState"]

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

    # Test that we can generate and write a kubeconfig
    (testpath/"kubeconfig").write ""
    system "KUBECONFIG=#{testpath}/kubeconfig #{bin}/oc config set-context foo 2>&1"
    assert_match "foo", shell_output("KUBECONFIG=#{testpath}/kubeconfig #{bin}/oc config get-contexts -o name")
  end
end
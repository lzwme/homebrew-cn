class OpenshiftCli < Formula
  desc "OpenShift command-line interface tools"
  homepage "https://www.openshift.com/"
  url "https://mirror.openshift.com/pub/openshift-v4/clients/ocp/4.20.10/openshift-client-src.tar.gz"
  # This project employs synchronized versioning so the sha256 may not change on version bumps
  sha256 "7ee2b4fdc6216c782185fa818aa13a2af08b00ac43aafd6b94dd127522241564"
  license "Apache-2.0"
  head "https://github.com/openshift/oc.git", shallow: false, branch: "main"

  livecheck do
    url "https://mirror.openshift.com/pub/openshift-v4/clients/ocp/stable/"
    regex(/href=.*?openshift-client-mac-(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e7e64ebac9163583a8c66bd3635641a03af94b24cdfe17bba2fbe4bb85ea6b38"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "453c7cd51b0b3d46c87f0276d0ec4e4be5e578d95df670514500bdfb7501efee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f7fb267ebd5ce27566d81d9c60226d6512247598c5ba269cfacffaa926a7f5aa"
    sha256 cellar: :any_skip_relocation, sonoma:        "9ec41e2e07e01df35f2bbb5694b3441a83ac91291c63de5fccb5f182cc335bb3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1a071615258ffecb00d61a19da834c009626af07a673abee3a4c40589f8cabf7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d7cb35c7864606a6edead4954fdaa588ebd9607dd1828700f9b660f5e5c7f9f8"
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
    generate_completions_from_executable(bin/"oc", shell_parameter_format: :cobra)
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
class OpenshiftCli < Formula
  desc "OpenShift command-line interface tools"
  homepage "https://www.openshift.com/"
  url "https://mirror.openshift.com/pub/openshift-v4/clients/ocp/4.19.9/openshift-client-src.tar.gz"
  # This project employs synchronized versioning so the sha256 may not change on version bumps
  sha256 "4c23bda233eaac582b812b9d4783be71f218de5124d673b4325377e8f325be2c"
  license "Apache-2.0"
  head "https://github.com/openshift/oc.git", shallow: false, branch: "main"

  livecheck do
    url "https://mirror.openshift.com/pub/openshift-v4/clients/ocp/stable/"
    regex(/href=.*?openshift-client-mac-(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "54b5acde58bef3e108743caa1dbfc1759cc536d9b080938bc79c20a1deef6d53"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "26a8525cc409122df1a5c12e1fcbee1198648cd09961e563212a673ba03de6d3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4a6834dcf6e3f37546b9564300a014b07058e5b764975da91d109f6d55579a1c"
    sha256 cellar: :any_skip_relocation, sonoma:        "84a0ad36778260f82267a9c8d2d8580f31955b591de77d8697afa32e72cb9349"
    sha256 cellar: :any_skip_relocation, ventura:       "f975be3713000736626131a02205d6a2b956bd3f45b015900c06138014651095"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "49f1b6e6ddf28db81cb4d3ea415861fbdca08b339992f19ea5b215aa741286c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "907772ae7d7bb3ca3f4f2eff82095cf21fc46678ea21b6544c3383fb2a7a156c"
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
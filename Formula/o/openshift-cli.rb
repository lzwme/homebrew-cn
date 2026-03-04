class OpenshiftCli < Formula
  desc "OpenShift command-line interface tools"
  homepage "https://www.openshift.com/"
  url "https://mirror.openshift.com/pub/openshift-v4/clients/ocp/4.21.3/openshift-client-src.tar.gz"
  # This project employs synchronized versioning so the sha256 may not change on version bumps
  sha256 "06e5172491145153c51b2ab40df040c49e608afca08d7cc0e29ad81f34a26141"
  license "Apache-2.0"
  head "https://github.com/openshift/oc.git", shallow: false, branch: "main"

  livecheck do
    url "https://mirror.openshift.com/pub/openshift-v4/clients/ocp/stable/"
    regex(/href=.*?openshift-client-mac-(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "13923d5b32e728564d2b999007f2be3fe5e0e795132da27aac0f7b894487a848"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e0f9942aaecff27cf04634489fc8b6e4fd9562755dcaf906cc0d609c3b95d3b9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d12b15cbdc47527dc400ed91401619c959dbc2a663c507ffda7e6c3753535c3b"
    sha256 cellar: :any_skip_relocation, sonoma:        "90b35a2ea3698f4a14e9c39d96bda197edfae71f199fed3a96ceed0de967ffad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8ba69356991c48eada064614437878dd708fe8c363a40b72b9f9e13a4422c02e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0964fb5d253f2fe9f54eb4e092baa4909c1909c17bb213e70e0c3f8a956e5aa8"
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
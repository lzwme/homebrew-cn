class OpenshiftCli < Formula
  desc "OpenShift command-line interface tools"
  homepage "https://www.openshift.com/"
  url "https://mirror.openshift.com/pub/openshift-v4/clients/ocp/4.13.17/openshift-client-src.tar.gz"
  sha256 "aad03ed90f51d332820ef593b1d96c082fc037caade07bff95d68c060a7d5098"
  license "Apache-2.0"
  head "https://github.com/openshift/oc.git", shallow: false, branch: "master"

  livecheck do
    url "https://mirror.openshift.com/pub/openshift-v4/clients/ocp/stable/"
    regex(/href=.*?openshift-client-mac-(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c9883f9ce023cefa690e1a305fc29c144199ce59fbc7f0912003df49dc3da536"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6f31e773e201f8081f9420169e916e5e405c8f6e09cd4e3f2dba986bd17f400d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e901f50d88a9757d8268b9d45b3eac2dc5ced49f517d43e9d6b0748cc54a122b"
    sha256 cellar: :any_skip_relocation, sonoma:         "0b08dd06e7dd288add809cbd19dbc58f9818053da6082a70a604964bd23aceec"
    sha256 cellar: :any_skip_relocation, ventura:        "6d4124f28b459e74a5a1654a3e64b1dabc47c74dc744e92f003a892b3fd1be91"
    sha256 cellar: :any_skip_relocation, monterey:       "0a001d9ffda47e7a766aebc2dfbfaad478233ac1f7147a61b1bcd9bcf9a01458"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "492d5c253474f3ff6c25b63609105c81ba6a6ceb66fd6ecf23d1506cde893804"
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
    generate_completions_from_executable(bin/"oc", "completion", base_name: "oc")
  end

  test do
    # Grab version details from built client
    version_raw = shell_output("#{bin}/oc version --client --output=json")
    version_json = JSON.parse(version_raw)

    # Ensure that we had a clean build tree
    assert_equal "clean", version_json["clientVersion"]["gitTreeState"]

    if stable?
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

    end

    # Test that we can generate and write a kubeconfig
    (testpath/"kubeconfig").write ""
    system "KUBECONFIG=#{testpath}/kubeconfig #{bin}/oc config set-context foo 2>&1"
    assert_match "foo", shell_output("KUBECONFIG=#{testpath}/kubeconfig #{bin}/oc config get-contexts -o name")
  end
end
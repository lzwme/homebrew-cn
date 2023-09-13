class OpenshiftCli < Formula
  desc "OpenShift command-line interface tools"
  homepage "https://www.openshift.com/"
  url "https://mirror.openshift.com/pub/openshift-v4/clients/ocp/4.13.11/openshift-client-src.tar.gz"
  sha256 "6b6ac6109dbbc8240a343d4a07661cf98ae008305bf432b58ca6b9c00c5a83d5"
  license "Apache-2.0"
  head "https://github.com/openshift/oc.git", shallow: false, branch: "master"

  livecheck do
    url "https://mirror.openshift.com/pub/openshift-v4/clients/ocp/stable/"
    regex(/href=.*?openshift-client-mac-(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "70a529e0637157470eb99b8938732b274bbc65ef0be7391535800c4bfe6be92f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3e82ae1dfeec1e3839a841433b8c3e6b7763cb7a7138bfc5f4c5c47a755b7f03"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fe90cbd777c21daf262efcec323486c0fad41bb3d44078e2dc59c7ce82e99aed"
    sha256 cellar: :any_skip_relocation, ventura:        "bd690f0ddd8770d1ff2c9810bbda29261a797e46ea84dc7a6859761499785a48"
    sha256 cellar: :any_skip_relocation, monterey:       "328bdba88f6519532bd5bdb9974aa488fe9bf9b440e9aec2fecfda81516ea388"
    sha256 cellar: :any_skip_relocation, big_sur:        "b106f8b67b8a9c6f1ca295cf80045b9eaa7d107005ea7a61aeb130049ecfd246"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "151b500d3b003aab60b82450c5c35ae90e1588f2c382058ee50057a6add10c04"
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
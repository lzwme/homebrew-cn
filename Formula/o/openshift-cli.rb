class OpenshiftCli < Formula
  desc "OpenShift command-line interface tools"
  homepage "https://www.openshift.com/"
  url "https://mirror.openshift.com/pub/openshift-v4/clients/ocp/4.13.13/openshift-client-src.tar.gz"
  sha256 "6b6ac6109dbbc8240a343d4a07661cf98ae008305bf432b58ca6b9c00c5a83d5"
  license "Apache-2.0"
  head "https://github.com/openshift/oc.git", shallow: false, branch: "master"

  livecheck do
    url "https://mirror.openshift.com/pub/openshift-v4/clients/ocp/stable/"
    regex(/href=.*?openshift-client-mac-(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "014f222733225c4fd831060454a7301bfc8c104c3e04974cfa9e9ae36c436929"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9aba85b32bd81bff35c966bec639b8e52d77080ecf8080b669b52100332c26e9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c9b046db8b9f18aae5c6259dea4b637090a9636a10c5b08e60205582782a470b"
    sha256 cellar: :any_skip_relocation, sonoma:         "74f597be3a56fb4f057464d35012abf3907ae96d7c9598fd1fb48c93d93af9af"
    sha256 cellar: :any_skip_relocation, ventura:        "37d740d11845051cce1e49485c55aa303a66718d1862c232c80bce128ceae2d1"
    sha256 cellar: :any_skip_relocation, monterey:       "e97194008936bf29ac8a1dba0d64c2432b9d38b6b1a6e2936e85df0656c53e13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "34597046d79e1dd76ff472e43b2eb9f80ad21f1f75a3ec6fd617653517ad1aef"
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
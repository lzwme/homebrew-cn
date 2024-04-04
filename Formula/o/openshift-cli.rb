class OpenshiftCli < Formula
  desc "OpenShift command-line interface tools"
  homepage "https:www.openshift.com"
  url "https:mirror.openshift.compubopenshift-v4clientsocp4.15.5openshift-client-src.tar.gz"
  sha256 "8999d3c360508e5dfdb741f21ec932258fef8d834e79130cea71c1b6839c46c9"
  license "Apache-2.0"
  head "https:github.comopenshiftoc.git", shallow: false, branch: "master"

  livecheck do
    url "https:mirror.openshift.compubopenshift-v4clientsocpstable"
    regex(href=.*?openshift-client-mac-(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cb40be412c557bf0225dc82da6aa494ab1329be5edc4c3ef3562da518ac1958c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "67eb78d143ffb68f581e556598f13080c15cd8d5bbb2896a6409ad4a9a1f9614"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5cc9403638633b39bc29ce5cbe95eee2034b1dd673b88ef5c5d1c2a9780eb45d"
    sha256 cellar: :any_skip_relocation, sonoma:         "1a136dafd375c722d46abb021b18616f31b98f10bbe36f1986956f07de321d88"
    sha256 cellar: :any_skip_relocation, ventura:        "e929787b70d5f0cf779761ba03c83d2768976637c69f769320c146ade5bf9e05"
    sha256 cellar: :any_skip_relocation, monterey:       "4ad72bee50e5cba1e7f252be7806aaeda56f727d1f58fe8632198a3a1a14e60f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fdeff7bf130013e938c40587d7ab8040bbe47f28314549b9ab4d7813a66e03da"
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

    if stable?
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

    end

    # Test that we can generate and write a kubeconfig
    (testpath"kubeconfig").write ""
    system "KUBECONFIG=#{testpath}kubeconfig #{bin}oc config set-context foo 2>&1"
    assert_match "foo", shell_output("KUBECONFIG=#{testpath}kubeconfig #{bin}oc config get-contexts -o name")
  end
end
class OpenshiftCli < Formula
  desc "OpenShift command-line interface tools"
  homepage "https://www.openshift.com/"
  url "https://mirror.openshift.com/pub/openshift-v4/clients/ocp/4.19.5/openshift-client-src.tar.gz"
  # This project employs synchronized versioning so the sha256 may not change on version bumps
  sha256 "4c23bda233eaac582b812b9d4783be71f218de5124d673b4325377e8f325be2c"
  license "Apache-2.0"
  head "https://github.com/openshift/oc.git", shallow: false, branch: "master"

  livecheck do
    url "https://mirror.openshift.com/pub/openshift-v4/clients/ocp/stable/"
    regex(/href=.*?openshift-client-mac-(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0e8715537e1bffaad6d85f60cada11b564ea5581045e1b93b66b21807b50af1d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d433c5cd6650b5e005fcb70b30acaa7624a3cb45d7bfde6a3cd1d3f8c00769b3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f83fddc266007343ab4932e3c59a519c05b1bad67527bba3b30fea90a06b19b3"
    sha256 cellar: :any_skip_relocation, sonoma:        "3bf7c6b28fd127ac6bd04514b4ccd76813f341cf980ad752ba914c6c9c32e4c1"
    sha256 cellar: :any_skip_relocation, ventura:       "9eaf4ca7808ef637a8ab3a96d30aaf943e10b17342a183f3c376d6ff659a9079"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f2bda6a87ba5036bdd085d6fbeeae7c8f17c7008696a5de2e9d4815f92f8261c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "24e8c487196ed93834379fd3bf5ae070f8d9a459cbaf01c4acf61a9fc43af8aa"
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
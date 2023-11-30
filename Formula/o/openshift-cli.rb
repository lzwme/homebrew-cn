class OpenshiftCli < Formula
  desc "OpenShift command-line interface tools"
  homepage "https://www.openshift.com/"
  url "https://mirror.openshift.com/pub/openshift-v4/clients/ocp/4.14.3/openshift-client-src.tar.gz"
  sha256 "495c9dfd054b377f5ffa7d3a2add613a397f7ffafaf109f8a5b0dcea4392d550"
  license "Apache-2.0"
  head "https://github.com/openshift/oc.git", shallow: false, branch: "master"

  livecheck do
    url "https://mirror.openshift.com/pub/openshift-v4/clients/ocp/stable/"
    regex(/href=.*?openshift-client-mac-(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ffcfecd5b2f715da047967a2c20ef4bc4ad07f19680758710311833f7ba5ea98"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bbd0f7d7f637b0e2f2b1cc57a2c0d3e7714dbeffa334c7e601a28ae3e6d3ffed"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d6fe38c640be472d2753e043faf551eea0f80c48ed2f0c54bc2589135084af95"
    sha256 cellar: :any_skip_relocation, sonoma:         "8f0304880d582b03dba2304db835501d56bc826a99fec652bb042f0cc363faea"
    sha256 cellar: :any_skip_relocation, ventura:        "14fda9bbaa21c78fac11194b868762815846a75ee0823d68c53a1abb42bfe016"
    sha256 cellar: :any_skip_relocation, monterey:       "85af5f1a33d946d13564b10062a9daa4431267727db5f1468af990ff51c8975d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a7041bd2f02abb635ec5f680452a0bc1a063e437dba91854c22eb6647b10275"
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
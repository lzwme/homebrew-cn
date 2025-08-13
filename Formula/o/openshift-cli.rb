class OpenshiftCli < Formula
  desc "OpenShift command-line interface tools"
  homepage "https://www.openshift.com/"
  url "https://mirror.openshift.com/pub/openshift-v4/clients/ocp/4.19.7/openshift-client-src.tar.gz"
  # This project employs synchronized versioning so the sha256 may not change on version bumps
  sha256 "4c23bda233eaac582b812b9d4783be71f218de5124d673b4325377e8f325be2c"
  license "Apache-2.0"
  head "https://github.com/openshift/oc.git", shallow: false, branch: "master"

  livecheck do
    url "https://mirror.openshift.com/pub/openshift-v4/clients/ocp/stable/"
    regex(/href=.*?openshift-client-mac-(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a09a62361c88585b1f361c3c46b6b07026c7c801a022620ebebe20603f63bb1c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1fee97e870ae45c7f33fd744e1cbec14340041a5525fd0fee4ce5f1d734aa3f8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "35f24fd09281082085f88c19571b1edaa00a080854ecdc95cfdda80182d6ca70"
    sha256 cellar: :any_skip_relocation, sonoma:        "8a3c20e6cd042e8f383d481041f4b9f563bd111982e45e7876106885aad78e07"
    sha256 cellar: :any_skip_relocation, ventura:       "4bbe5ae452b767cafb572be92dc4d373066631be02e18b811949005d28d9301f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a34869066ecf7f93994a4f4e7880bae7a116e42a7bdb8262f51ff3edfd37387f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b8f24a1fc29e643a72f6eff1f0fe38e54b3537eb92c94ca0d1ab6272b26c4fef"
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
class OpenshiftCli < Formula
  desc "OpenShift command-line interface tools"
  homepage "https:www.openshift.com"
  url "https:mirror.openshift.compubopenshift-v4clientsocp4.15.17openshift-client-src.tar.gz"
  sha256 "a7ecc96a0f70020d0b02a7c408cf11b30e63bc6a4cd37dae747f5675532ffa08"
  license "Apache-2.0"
  head "https:github.comopenshiftoc.git", shallow: false, branch: "master"

  livecheck do
    url "https:mirror.openshift.compubopenshift-v4clientsocpstable"
    regex(href=.*?openshift-client-mac-(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9dd94ba37bd7041df9992562a507332e142da13db8fdf5d26f222c7fb4033be6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "90c87330dbff406ae55ba4bc91031581d6ca7d9ae7ec8cd20469f32e7179ecb1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "74340f19065111232920313c470f62cda15c4bd4b414e93d75f3473b386cc4c9"
    sha256 cellar: :any_skip_relocation, sonoma:         "842a2cc0947ad23eaf867e1ec4c9081c79efdd7fff2c82a544dcea2ffe6215e8"
    sha256 cellar: :any_skip_relocation, ventura:        "b1e8cbaaf2a5fea03fab13a5ba8b75bd269c1a31b0ab305b88cdf1915cf30123"
    sha256 cellar: :any_skip_relocation, monterey:       "2d1a769f76c60894c07fed17208379bb35eb89797eefc025ad98e2c2bf9a5d2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9a964e2fa248730ed82e9a34356c2d5c16840f19361aa26becf66330c5909443"
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
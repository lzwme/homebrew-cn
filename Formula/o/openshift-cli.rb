class OpenshiftCli < Formula
  desc "OpenShift command-line interface tools"
  homepage "https:www.openshift.com"
  url "https:mirror.openshift.compubopenshift-v4clientsocp4.18.12openshift-client-src.tar.gz"
  # This project employs synchronized versioning so the sha256 may not change on version bumps
  sha256 "583abfd280c49a651f9edabb0ea3988ec2bc961c8723a24d6705ec1232c241ba"
  license "Apache-2.0"
  head "https:github.comopenshiftoc.git", shallow: false, branch: "master"

  livecheck do
    url "https:mirror.openshift.compubopenshift-v4clientsocpstable"
    regex(href=.*?openshift-client-mac-(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "640b59e9c31a7b89430e6d585dfe8fdc4e0111574f7f9a1aa2c48c50e2bad501"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0f209ce30ea92f8e70c4b35e9bcde7374fcc98d3fe6976b43ae0f226d04abd12"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e6a5546a30eb281fb76636ccff6dabf77745b58f2c85ded3765929785a5bd98f"
    sha256 cellar: :any_skip_relocation, sonoma:        "4e2c33356eb9d7bf4a5da06e2c327c0ca5f96a795efef8aa8ac2cb4d8edace0a"
    sha256 cellar: :any_skip_relocation, ventura:       "1f67da91ca17357ccb1bf7a38ee5f0d036c9843bb8b13ef17f6fcf745656cc1a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "015a63b57578926dbbfba839b4884da1294517ebc250b33466b5446126c95091"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "28ef815f319febed17c816e819c96b3cd13deebaa79d686a2ded6c8361742bc2"
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
    generate_completions_from_executable(bin"oc", "completion")
  end

  test do
    # Grab version details from built client
    version_raw = shell_output("#{bin}oc version --client --output=json")
    version_json = JSON.parse(version_raw)

    # Ensure that we had a clean build tree
    assert_equal "clean", version_json["clientVersion"]["gitTreeState"]

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

    # Test that we can generate and write a kubeconfig
    (testpath"kubeconfig").write ""
    system "KUBECONFIG=#{testpath}kubeconfig #{bin}oc config set-context foo 2>&1"
    assert_match "foo", shell_output("KUBECONFIG=#{testpath}kubeconfig #{bin}oc config get-contexts -o name")
  end
end
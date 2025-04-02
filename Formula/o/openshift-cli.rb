class OpenshiftCli < Formula
  desc "OpenShift command-line interface tools"
  homepage "https:www.openshift.com"
  url "https:mirror.openshift.compubopenshift-v4clientsocp4.18.6openshift-client-src.tar.gz"
  # This project employs synchronized versioning so the sha256 may not change on version bumps
  sha256 "583abfd280c49a651f9edabb0ea3988ec2bc961c8723a24d6705ec1232c241ba"
  license "Apache-2.0"
  head "https:github.comopenshiftoc.git", shallow: false, branch: "master"

  livecheck do
    url "https:mirror.openshift.compubopenshift-v4clientsocpstable"
    regex(href=.*?openshift-client-mac-(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "99d5044b5863305b5b8b10eeb7a60c3d4d014ea2fadab2125ac6d95e3565a955"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "abfee43095d00e449ebd3c067fdc52f8e22863e4ece9b45ebd1205f174f0960d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "57d3204d6053a20d7b2fa35e28c51ba8372cf042e359d2238e2e325dfa48b0fb"
    sha256 cellar: :any_skip_relocation, sonoma:        "b84b8f79b4f99a397a6aad481a9f1dee2dae46e00ad8bf2244c394e699f613e3"
    sha256 cellar: :any_skip_relocation, ventura:       "8a5736759dac09c5c21e6a1037b83bd6d8e699420f2d2da57e663506f1493963"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "577a029d1d4c26e08a66d706948fb7e7cd27e09766e43927a68735d7fc6b6c5c"
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
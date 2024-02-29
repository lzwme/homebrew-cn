class OpenshiftCli < Formula
  desc "OpenShift command-line interface tools"
  homepage "https:www.openshift.com"
  url "https:mirror.openshift.compubopenshift-v4clientsocp4.15.0openshift-client-src.tar.gz"
  sha256 "954075655e06fef8333d5188ef3eb2533ebf1aaae2fa35cb6813199ed35e8232"
  license "Apache-2.0"
  head "https:github.comopenshiftoc.git", shallow: false, branch: "master"

  livecheck do
    url "https:mirror.openshift.compubopenshift-v4clientsocpstable"
    regex(href=.*?openshift-client-mac-(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "350e94c81f853c54075c7d6fc6df07fa3f9651daadd8aad0c600e0675da7dc6a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "38e404834ecf386a0280de1b2b914151ff1474212ae56289a2a6037631f46712"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "52383bdfe8d8049dad386a86fe2722a9c50b0f93b88ed8ec045624a63a4ec8ec"
    sha256 cellar: :any_skip_relocation, sonoma:         "33db9016c64928084006b2d1fbe2db78f3c49699cff6dda1a73a84f01117c61d"
    sha256 cellar: :any_skip_relocation, ventura:        "e2def3332d280633c98ba103e14aabd07a4f0177c8a9b0885958084baf0613b7"
    sha256 cellar: :any_skip_relocation, monterey:       "1c8e32761e8f0fb5c0f83128efb45c5b54a42830af910b0fe641ea9ac4dabea0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d75c7a638afd633c19b9af37734fbb40f0c5ef7f2685b4eafbc26ff3f575b36a"
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
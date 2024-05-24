class OpenshiftCli < Formula
  desc "OpenShift command-line interface tools"
  homepage "https:www.openshift.com"
  url "https:mirror.openshift.compubopenshift-v4clientsocp4.15.13openshift-client-src.tar.gz"
  sha256 "a7ecc96a0f70020d0b02a7c408cf11b30e63bc6a4cd37dae747f5675532ffa08"
  license "Apache-2.0"
  head "https:github.comopenshiftoc.git", shallow: false, branch: "master"

  livecheck do
    url "https:mirror.openshift.compubopenshift-v4clientsocpstable"
    regex(href=.*?openshift-client-mac-(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e46acdb4cc53af704aa562d84fcdac6fdf293ed35ab7ce31d4035d5449ab4925"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3bba40e85374c708672a335eab9b19d0840cc84fc8465d3e1c7320b7f01e8ab2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4e9ed561522284a435d7f909e700a2154c5e70a3ef83d1dd9f03a32cde517376"
    sha256 cellar: :any_skip_relocation, sonoma:         "e792ecc0d37e330eaaa8027d8970a0d9bd52186dccf9a4b6503c07a16adf4bde"
    sha256 cellar: :any_skip_relocation, ventura:        "bd8a4fab3f35099aba600ba3388002842527df9f62f97c5a2903d2ec1fc500fd"
    sha256 cellar: :any_skip_relocation, monterey:       "baee6653e229a6b2815ae31f11bdee7a24e2360a1e0c666f8cb898b4bec972a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "91a1d87d0ecba09d2a1dff19995d54a51d076a421085ca3ac2e0b6869657b82e"
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
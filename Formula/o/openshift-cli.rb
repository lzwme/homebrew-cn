class OpenshiftCli < Formula
  desc "OpenShift command-line interface tools"
  homepage "https:www.openshift.com"
  url "https:mirror.openshift.compubopenshift-v4clientsocp4.18.11openshift-client-src.tar.gz"
  # This project employs synchronized versioning so the sha256 may not change on version bumps
  sha256 "583abfd280c49a651f9edabb0ea3988ec2bc961c8723a24d6705ec1232c241ba"
  license "Apache-2.0"
  head "https:github.comopenshiftoc.git", shallow: false, branch: "master"

  livecheck do
    url "https:mirror.openshift.compubopenshift-v4clientsocpstable"
    regex(href=.*?openshift-client-mac-(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "74eb452cb9ff88aba88df2e45dd32734e2f653d4ddebbf593b54d631243ee82d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "78cee8529089ee6ea61e3dab4b06cba9a1941a9bcda43d13c2966df4877c13c8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "78274300844fad42a6c9ef4bb4e1eb6f7d3a052d6a9be886f61b7d097548ee5f"
    sha256 cellar: :any_skip_relocation, sonoma:        "81d2a8daf19e19d584d1118c6e32c51d8e3a3b45e488dccd8880e6598f601deb"
    sha256 cellar: :any_skip_relocation, ventura:       "6793c1bdc9ae4b485471d929046639f3be60862626901e374eddc9dbc4f5f138"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "467258705086671466766543366571a3e0217452a3dd2d18edcacb9470c8fa8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f90004831bdcba5dab2325f8b15ce6ff17314836051440a03b316bc6afb0e615"
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
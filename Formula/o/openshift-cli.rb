class OpenshiftCli < Formula
  desc "OpenShift command-line interface tools"
  homepage "https:www.openshift.com"
  url "https:mirror.openshift.compubopenshift-v4clientsocp4.16.9openshift-client-src.tar.gz"
  # This project employs synchronized versioning so the sha256 may not change on version bumps
  sha256 "1be74704436e803ab6932a96d0abd037319b2ea05f9706c7e33d9103af724d19"
  license "Apache-2.0"
  head "https:github.comopenshiftoc.git", shallow: false, branch: "master"

  livecheck do
    url "https:mirror.openshift.compubopenshift-v4clientsocpstable"
    regex(href=.*?openshift-client-mac-(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a36fa9e5b5ddbf8f0f2a2a30eb17a89ed87c9640e21b889fe5111107ac1306d9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e135c7f37003581bf8bf868e2a895e7ba45a0af70a83f8112b500176cb6dbb40"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "744040531c08224f80201bd1c25e56d6865dc6db62753ae2a30f4a8c3c1db605"
    sha256 cellar: :any_skip_relocation, sonoma:         "99c46a29d6f669642d0d91da531c8118dcb4daedd62245e678487dc042e2815b"
    sha256 cellar: :any_skip_relocation, ventura:        "8ee1cae84a1a74246b7ce5d469dc84fea729eeebb474439cae69fc1c8228d74b"
    sha256 cellar: :any_skip_relocation, monterey:       "0b7dbfc9469a49a0ce87c53263ad891fafc05d189981587cb32b24ba73ff1750"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cfef5806c76a8652be6a9c413535d1f1cb747908515d82fb7b7f412a87644b05"
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
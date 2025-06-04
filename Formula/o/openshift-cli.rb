class OpenshiftCli < Formula
  desc "OpenShift command-line interface tools"
  homepage "https:www.openshift.com"
  url "https:mirror.openshift.compubopenshift-v4clientsocp4.18.15openshift-client-src.tar.gz"
  # This project employs synchronized versioning so the sha256 may not change on version bumps
  sha256 "fcbf4750ecb1131f61b9efd20f82fb5df3b4ff965d8ae68acb2a9b0c4ff380c7"
  license "Apache-2.0"
  head "https:github.comopenshiftoc.git", shallow: false, branch: "master"

  livecheck do
    url "https:mirror.openshift.compubopenshift-v4clientsocpstable"
    regex(href=.*?openshift-client-mac-(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2a9129d834943698925c115fc970db67587c4887100b569b907bb547d4e21bb8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "be570d73d81577535922cc48f870cb09b90fe11e48e4397f5ce2826fd43d6e22"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ab76d3eb4d0b2291d1541265e80d530be83bf38b6cac35472bfd56f348e6d4b8"
    sha256 cellar: :any_skip_relocation, sonoma:        "4d9db5e2efa6e5ef4e5c8d71408c63194414758987679aaad310a8ea201c3f57"
    sha256 cellar: :any_skip_relocation, ventura:       "9a6f1e9045ae961325b58e292e146d2c3d6c33acb1fe5e9ac0be62a19bc68841"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a5864f90e0c4d1b58b44c4ae9886aa3c71bcc43e361840e2a67d6ee9728207f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd87a16f320688dcf9a6f31162be17af632f1caa229fab8874f63234c24c1410"
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
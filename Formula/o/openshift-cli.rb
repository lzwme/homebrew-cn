class OpenshiftCli < Formula
  desc "OpenShift command-line interface tools"
  homepage "https:www.openshift.com"
  url "https:mirror.openshift.compubopenshift-v4clientsocp4.17.7openshift-client-src.tar.gz"
  # This project employs synchronized versioning so the sha256 may not change on version bumps
  sha256 "0eb9cdaab6c0adcab13bc7e4e9beef4b1339b2c7e7e99c2199cdd4817cb3a754"
  license "Apache-2.0"
  head "https:github.comopenshiftoc.git", shallow: false, branch: "master"

  livecheck do
    url "https:mirror.openshift.compubopenshift-v4clientsocpstable"
    regex(href=.*?openshift-client-mac-(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a669e9ea7f017a02a19896b1a7e11b6d60829da30a087be7b40adb5e17852f58"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "13d44c56e15ab322b4ba4bd720188b7b835b46e01900358be3d09f437335b827"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4daef9aa03a00a8be1df4641ed5beee635c5e8a8f61ff98d3ca8b6b9815ac648"
    sha256 cellar: :any_skip_relocation, sonoma:        "214da25c4a6cc039ee678a469f404168d9ba09733d8b90acd24252c64a9ef14d"
    sha256 cellar: :any_skip_relocation, ventura:       "258cfbe3d92e55e8f3a317c2fa02ad0454c02d949f5c5b29b5cdf5372f78df7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c5103891e83becc24422123f5c455d8a05abd9c2e57963c3bb379f13c18713a6"
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
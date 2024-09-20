class OpenshiftCli < Formula
  desc "OpenShift command-line interface tools"
  homepage "https:www.openshift.com"
  url "https:mirror.openshift.compubopenshift-v4clientsocp4.16.11openshift-client-src.tar.gz"
  # This project employs synchronized versioning so the sha256 may not change on version bumps
  sha256 "c19c67a9655abf6c48aecd10a4ffb900c6bc2798864ca0a757cb8df172311e29"
  license "Apache-2.0"
  head "https:github.comopenshiftoc.git", shallow: false, branch: "master"

  livecheck do
    url "https:mirror.openshift.compubopenshift-v4clientsocpstable"
    regex(href=.*?openshift-client-mac-(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c11d9ee3497b3662fc9032e665c201cf17a07076bbed7b1e0cd101cbb11866a1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8a4dfd998353b87fceabb1bd5a565c6933d2742554ddecbf7bd695e1b6853170"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9d9e3e4039af6d203980549635e0869360f04ba135603651ebf5d1d6944db948"
    sha256 cellar: :any_skip_relocation, sonoma:        "63e6db98b07b52eaa8507555e189450047f494e6ece4d2841595003787950cd6"
    sha256 cellar: :any_skip_relocation, ventura:       "23482ed2de55f970203c74a5cd903df86116bcaa5bcde01de9968b43993d3778"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "da020a2c146699605108c90ffa47db564f4f9990e6259fc1f2868d5a8b94512a"
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
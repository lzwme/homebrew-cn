class OpenshiftCli < Formula
  desc "OpenShift command-line interface tools"
  homepage "https:www.openshift.com"
  url "https:mirror.openshift.compubopenshift-v4clientsocp4.17.15openshift-client-src.tar.gz"
  # This project employs synchronized versioning so the sha256 may not change on version bumps
  sha256 "42be4d7b00b12720cb1aa545838bd39ec61365c3b97df628ad22d0e827831c79"
  license "Apache-2.0"
  head "https:github.comopenshiftoc.git", shallow: false, branch: "master"

  livecheck do
    url "https:mirror.openshift.compubopenshift-v4clientsocpstable"
    regex(href=.*?openshift-client-mac-(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1eed1c8bfa3f754ebd50dbc8a9b54cff5c6af10093ce4d5a1af6425fe536aac4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "141ea04bd9196bc015ea12fd8efa61a836236d4c9d8126c377208dd2468288fb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "04f2cacdbed9f54de5e5b78eba70f8d3a9f5617df2bec7aab3625e9223e82dfd"
    sha256 cellar: :any_skip_relocation, sonoma:        "e0b425ef696ae5f2f50e7a5a6731adbd5961a86010e8ac4f58167b5c13fd6bc8"
    sha256 cellar: :any_skip_relocation, ventura:       "05df8021bcabdc474380f38d35c369f6471a8e26a9a66aff967955590cbe00d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b6c2aac81c91d92e9ae44044bee97b6c38a3bf23f78731f327dda69eab70053"
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
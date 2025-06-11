class OpenshiftCli < Formula
  desc "OpenShift command-line interface tools"
  homepage "https:www.openshift.com"
  url "https:mirror.openshift.compubopenshift-v4clientsocp4.18.16openshift-client-src.tar.gz"
  # This project employs synchronized versioning so the sha256 may not change on version bumps
  sha256 "6695245d3ff02d6a4de3f5b815614528cddfb92f11751bf5116a05685b5295f0"
  license "Apache-2.0"
  head "https:github.comopenshiftoc.git", shallow: false, branch: "master"

  livecheck do
    url "https:mirror.openshift.compubopenshift-v4clientsocpstable"
    regex(href=.*?openshift-client-mac-(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3a0260f0741e2541b03cd6918e1dc7f4a5c98e695017ec0d30116e7d58f17337"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6f2d95110fbf19349790f272c04b6ddb51ec08273f140c553df1933efc61507d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e5062bd77e53e83d54013036d2168fe238cd2e8b6013f0bdd73169562c5ce03f"
    sha256 cellar: :any_skip_relocation, sonoma:        "e9cc2f7fc0bb8c54920f7ac09636daacc56b5095e0bfd8ba98557395457b48b7"
    sha256 cellar: :any_skip_relocation, ventura:       "b031f0b58103310f1e79960be815443c7e845eb175588b74fee4c3da0baffb98"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "616ff27d2d20fd478d7828c7ab61a778cb302ef77df8fb35408f41636eb4d549"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "379bb664ff2f7b2728d40e53d6506f6691980a5562aa9798d2165041626bfe02"
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
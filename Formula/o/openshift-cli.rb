class OpenshiftCli < Formula
  desc "OpenShift command-line interface tools"
  homepage "https:www.openshift.com"
  url "https:mirror.openshift.compubopenshift-v4clientsocp4.18.4openshift-client-src.tar.gz"
  # This project employs synchronized versioning so the sha256 may not change on version bumps
  sha256 "583abfd280c49a651f9edabb0ea3988ec2bc961c8723a24d6705ec1232c241ba"
  license "Apache-2.0"
  head "https:github.comopenshiftoc.git", shallow: false, branch: "master"

  livecheck do
    url "https:mirror.openshift.compubopenshift-v4clientsocpstable"
    regex(href=.*?openshift-client-mac-(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ce997c3836eb7ca27356f6d2926617c5cf00fe79fb0f4e225442f56bc265a4d9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1f9e4c7891a4e294d728daf5c292a77d5a34fa80b3d669b60058c29ca3da8375"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d3beaf6b0302210211382f40d79646325ef2b8079db31b0d12d42c47d2fe046d"
    sha256 cellar: :any_skip_relocation, sonoma:        "99c9077ee196f78b0a4e670790d2edd41165fda437ef56bd7ad05ba8035c0abb"
    sha256 cellar: :any_skip_relocation, ventura:       "6d36ed5c679677a6e3a62ad74c79e1bb7657bd92abbb5a2a7745e83a0d43cb28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "93c6dac53f87a47410ffdec2868484ad95cfcebdc724fe907c7d9fd09f2e738e"
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
class OpenshiftCli < Formula
  desc "OpenShift command-line interface tools"
  homepage "https:www.openshift.com"
  url "https:mirror.openshift.compubopenshift-v4clientsocp4.16.1openshift-client-src.tar.gz"
  sha256 "fc75e6240c6449854dc3afacce820671359d9d41032a6c52d428ad3c9880c5e0"
  license "Apache-2.0"
  head "https:github.comopenshiftoc.git", shallow: false, branch: "master"

  livecheck do
    url "https:mirror.openshift.compubopenshift-v4clientsocpstable"
    regex(href=.*?openshift-client-mac-(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4a7b0511b9c538235c11b58157358e515c67eddbf3b04ba5589bb2e653775ed8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a66aac5983209dd9de1550390dc1f86f64ae13bd30a56b189b9c958dde7f73fe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "10810a050159173e0ee96bb8a4b00d855c4a9c9e8dc68d3c8bd358096ff8584d"
    sha256 cellar: :any_skip_relocation, sonoma:         "c1913f76a816577cc84baad4686e76a1e57c29e8d02381e92cc1f6bebf74e81a"
    sha256 cellar: :any_skip_relocation, ventura:        "e464755ef2165d605c4de9891986aef51fa4229a02a6ac7b422956b77901aac5"
    sha256 cellar: :any_skip_relocation, monterey:       "f708af2591e76334356364f09d679c6434a3983cd3a17b51a50011d2d397e490"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e2ce1a71dbdc953b1c1679ba81cfef22db73fcfb2579bf33508658c81fc6c8b9"
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
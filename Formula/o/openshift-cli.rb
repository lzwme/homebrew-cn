class OpenshiftCli < Formula
  desc "OpenShift command-line interface tools"
  homepage "https://www.openshift.com/"
  url "https://mirror.openshift.com/pub/openshift-v4/clients/ocp/4.14.2/openshift-client-src.tar.gz"
  sha256 "495c9dfd054b377f5ffa7d3a2add613a397f7ffafaf109f8a5b0dcea4392d550"
  license "Apache-2.0"
  head "https://github.com/openshift/oc.git", shallow: false, branch: "master"

  livecheck do
    url "https://mirror.openshift.com/pub/openshift-v4/clients/ocp/stable/"
    regex(/href=.*?openshift-client-mac-(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "06a6e7112e2753fe50c1ff00175e0b82352796e8617447e519b3937f402ffe4b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "db1ef152f3dd675d738642b58cf17c877bb98a916e1eab8f862888e07afb339d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d3eb9c562ce6f576fe262fcfb06c569c41ea84fd3af9e2c4ba8d6442e348edb7"
    sha256 cellar: :any_skip_relocation, sonoma:         "3dcdbbf1ace5edfd6133435d776f1e793124b2c56c7ffde30152bb88561317e9"
    sha256 cellar: :any_skip_relocation, ventura:        "ad7d4f76155535f044098af89fc67626f1ff75072fdf2b0c1b0b13c8c5dad9d2"
    sha256 cellar: :any_skip_relocation, monterey:       "4df00d0c5ea2b42f662c1115ca8a74b7261ea1e1c06dd955cc96ffebf617ea6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0fa2e7e0afbd81d85b266f3932badd5abf9ce5e6a98fb689b450066c5bee3c46"
  end

  depends_on "go" => :build
  uses_from_macos "krb5"

  def install
    arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
    os = OS.kernel_name.downcase
    revision = build.head? ? Utils.git_head : Pathname.pwd.basename.to_s.delete_prefix("oc-")

    # See https://github.com/Homebrew/brew/issues/14763
    ENV.O0 if OS.linux?

    system "make", "cross-build-#{os}-#{arch}", "OS_GIT_VERSION=#{version}", "SOURCE_GIT_COMMIT=#{revision}", "SHELL=/bin/bash"
    bin.install "_output/bin/#{os}_#{arch}/oc"
    generate_completions_from_executable(bin/"oc", "completion", base_name: "oc")
  end

  test do
    # Grab version details from built client
    version_raw = shell_output("#{bin}/oc version --client --output=json")
    version_json = JSON.parse(version_raw)

    # Ensure that we had a clean build tree
    assert_equal "clean", version_json["clientVersion"]["gitTreeState"]

    if stable?
      # Verify the built artifact matches the formula
      assert_match version_json["clientVersion"]["gitVersion"], "v#{version}"

      # Get remote release details
      release_raw = shell_output("#{bin}/oc adm release info #{version} --output=json")
      release_json = JSON.parse(release_raw)

      # Verify the formula matches the release data for the version
      assert_match version_json["clientVersion"]["gitCommit"],
        release_json["references"]["spec"]["tags"].find { |tag|
          tag["name"]=="cli"
        } ["annotations"]["io.openshift.build.commit.id"]

    end

    # Test that we can generate and write a kubeconfig
    (testpath/"kubeconfig").write ""
    system "KUBECONFIG=#{testpath}/kubeconfig #{bin}/oc config set-context foo 2>&1"
    assert_match "foo", shell_output("KUBECONFIG=#{testpath}/kubeconfig #{bin}/oc config get-contexts -o name")
  end
end
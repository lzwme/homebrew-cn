class Kubie < Formula
  desc "Much more powerful alternative to kubectx and kubens"
  homepage "https://blog.sbstp.ca/introducing-kubie/"
  url "https://ghproxy.com/https://github.com/sbstp/kubie/archive/v0.20.0.tar.gz"
  sha256 "ca0919afc33fa903a7a5e8adeff53a700c66896aa842534ea2e48631ef8cb8fd"
  license "Zlib"
  head "https://github.com/sbstp/kubie.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7c5ee25739723a7695c157bdcb9c039ccf5220236be64615bfc7063aa6b6f79c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "18d1bddc26587bbf39d80283ed38ddfa8f4dac6eefacb20e128118da95d6b824"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fab2313df8e69457b47f9a4cd6a54a6047f3920ecc83203904644e38ef01c024"
    sha256 cellar: :any_skip_relocation, ventura:        "c32c8f1e73360a7aedab00795f40ac79851e40e9c35b517e606787a1029670b4"
    sha256 cellar: :any_skip_relocation, monterey:       "3db9fffd5c0290763949c16684d0ba92279a89027f47e7f0d6dce96167c36cef"
    sha256 cellar: :any_skip_relocation, big_sur:        "ef17bb591d2593f56c07397e9ea3c04a1ed8732ea163b998e9e5d3d189c9ad39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d19282d9254ee5ded37799731bbb488e9e9d879ba0b1d365c8f67f1e8cfcf435"
  end

  depends_on "rust" => :build
  depends_on "kubernetes-cli" => :test

  def install
    system "cargo", "install", *std_cargo_args
    bash_completion.install "./completion/kubie.bash"
    fish_completion.install "./completion/kubie.fish"
  end

  test do
    (testpath/".kube/kubie-test.yaml").write <<~EOS
      apiVersion: v1
      clusters:
      - cluster:
          server: http://0.0.0.0/
        name: kubie-test-cluster
      contexts:
      - context:
          cluster: kubie-test-cluster
          user: kubie-test-user
          namespace: kubie-test-namespace
        name: kubie-test
      current-context: baz
      kind: Config
      preferences: {}
      users:
      - user:
        name: kubie-test-user
    EOS

    assert_match "The connection to the server 0.0.0.0 was refused - did you specify the right host or port?",
      shell_output("#{bin}/kubie exec kubie-test kubie-test-namespace kubectl get pod 2>&1")
  end
end
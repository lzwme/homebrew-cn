class ApifyCli < Formula
  desc "Apify command-line interface"
  homepage "https://docs.apify.com/cli/"
  url "https://registry.npmjs.org/apify-cli/-/apify-cli-0.21.5.tgz"
  sha256 "1b37c95ba5e237cb84188094e7e92fada0fab62976314b9eb401537cb63ca2fa"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ea86fce02839d16b3a35a0160cedb903fc3b8c2bc49090ad4d51ed12c26b61a0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ea86fce02839d16b3a35a0160cedb903fc3b8c2bc49090ad4d51ed12c26b61a0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ea86fce02839d16b3a35a0160cedb903fc3b8c2bc49090ad4d51ed12c26b61a0"
    sha256 cellar: :any_skip_relocation, sonoma:        "bb87b75c45cc2e65298b29e1c1083408900b09ff1d4b165bc7894bfd338e9ade"
    sha256 cellar: :any_skip_relocation, ventura:       "bb87b75c45cc2e65298b29e1c1083408900b09ff1d4b165bc7894bfd338e9ade"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "654b3454cf39a857064b1fad65dcac26743f8db2fc18c3011829314201a8629c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "654b3454cf39a857064b1fad65dcac26743f8db2fc18c3011829314201a8629c"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/apify init -y testing-actor 2>&1")
    assert_includes output, "Success: The Actor has been initialized in the current directory"
    assert_path_exists testpath/"storage/key_value_stores/default/INPUT.json"

    assert_includes shell_output("#{bin}/apify --version 2>&1"), version.to_s
  end
end
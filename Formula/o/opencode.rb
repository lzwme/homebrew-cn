class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.0.46.tgz"
  sha256 "47c6c1414eabb65044ea4f2b47cd1486d802dd597a1d11674f47b15e2fb44ce8"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "cecd4cd87c3212c34d2c48e7cf553928bd1298eb77d31f679df95d99e11d2aff"
    sha256                               arm64_sequoia: "cecd4cd87c3212c34d2c48e7cf553928bd1298eb77d31f679df95d99e11d2aff"
    sha256                               arm64_sonoma:  "cecd4cd87c3212c34d2c48e7cf553928bd1298eb77d31f679df95d99e11d2aff"
    sha256 cellar: :any_skip_relocation, sonoma:        "dbfa9a08f8597970974c70c2d742e2e64bf79ece2a6ed4fcd62489e1014ced71"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c963c347e3a5c164eae82e6e42eb941544e4c95be70d7b789b98500a35e0a61c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b8cc89ef291ff0140bb57992ea749bad6068e02200041d13ba41ad7dcdf531f4"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/opencode --version")
    assert_match "opencode", shell_output("#{bin}/opencode models")
  end
end
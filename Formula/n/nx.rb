class Nx < Formula
  desc "Smart, Fast and Extensible Build System"
  homepage "https://nx.dev"
  url "https://registry.npmjs.org/nx/-/nx-22.5.4.tgz"
  sha256 "2da35f33adebc3f53dc5a8bfd426d277c5105203bbafa822dd030f992b09e7e2"
  license "MIT"
  version_scheme 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e0534d16c70b477b3adcd094855acf6e5343a6996aee8f5c9ad91b0f48f18961"
    sha256 cellar: :any,                 arm64_sequoia: "1bc71f39d6b1a0a2491ff15e5c69b72f455344be43a0813420f9ad0524562999"
    sha256 cellar: :any,                 arm64_sonoma:  "1bc71f39d6b1a0a2491ff15e5c69b72f455344be43a0813420f9ad0524562999"
    sha256 cellar: :any,                 sonoma:        "4cd58ed7c3c845f1023672baa7b9f0a268b2372c812550f7632085ef5697d5c0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6f19d29d869c12c21344edcf594a66c6936bceb8fafaae3355a540a0bf097dae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7310955763c59f75cafd50478afe53caec9706a4da92467954bf99693be487b0"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    (testpath/"package.json").write <<~JSON
      {
        "name": "@acme/repo",
        "version": "0.0.1",
        "scripts": {
          "test": "echo 'Tests passed'"
        }
      }
    JSON

    system bin/"nx", "init", "--no-interactive"
    assert_path_exists testpath/"nx.json"

    output = shell_output("#{bin}/nx test").gsub(/\e\[[0-9;]*m/, "")
    assert_match "Successfully ran target test for project @acme/repo", output
  end
end
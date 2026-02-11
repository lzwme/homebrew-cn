class Nx < Formula
  desc "Smart, Fast and Extensible Build System"
  homepage "https://nx.dev"
  url "https://registry.npmjs.org/nx/-/nx-22.5.0.tgz"
  sha256 "eab9e95a35e20260a7216ab1884e1f154d4dcefb4a5cceb636e2a641a31574b9"
  license "MIT"
  version_scheme 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "757a6fb799100435858ddadacdad62455945e68eb61dabe3e067f559c5a3e66f"
    sha256 cellar: :any,                 arm64_sequoia: "6dfc421b06e46aff9080a7124f53880ed0be0f308ae4401151e4d9d3cd3a97e2"
    sha256 cellar: :any,                 arm64_sonoma:  "6dfc421b06e46aff9080a7124f53880ed0be0f308ae4401151e4d9d3cd3a97e2"
    sha256 cellar: :any,                 sonoma:        "84374e05c959cf9b339bb5f0c51f031992ad88f5aad0454e48a5a523cbcea1ec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d92b83d0694f02edfd155ade0cf4e04e8bc1dfc93b11f35dc6bb36694cbe56b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6073ca1f683d73b3217d40c11844f47f39dd7436da1214122220cea91f0a4d00"
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
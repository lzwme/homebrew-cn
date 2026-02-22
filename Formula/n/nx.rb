class Nx < Formula
  desc "Smart, Fast and Extensible Build System"
  homepage "https://nx.dev"
  url "https://registry.npmjs.org/nx/-/nx-22.5.2.tgz"
  sha256 "3831baa66b40ee4e19ba2b2d5682a1c75aede1b66c8a55dc26a5fc24ca0a43a7"
  license "MIT"
  version_scheme 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9de72e63a746c1204d15dc87ee2645b98c30dadfd29422dba8ccf974b33c673f"
    sha256 cellar: :any,                 arm64_sequoia: "103a32034e6f64abbcaabca67c5814912956d380b5e44856b1309821f9f3aa35"
    sha256 cellar: :any,                 arm64_sonoma:  "103a32034e6f64abbcaabca67c5814912956d380b5e44856b1309821f9f3aa35"
    sha256 cellar: :any,                 sonoma:        "cd3f116e88caf1900e828dda4b8ec67ccf450a202e67978c987a2bedfe55119a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e0e235a828dedc1c1a40663c82f1fd49b67240efc990c23a1eb4c80563881502"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2132cbdcff7d39a925ee80e6278f1eba00c909f443dd70930a8448869ffdb00d"
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
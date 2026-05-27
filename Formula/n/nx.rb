class Nx < Formula
  desc "Smart, Fast and Extensible Build System"
  homepage "https://nx.dev"
  url "https://registry.npmjs.org/nx/-/nx-22.7.4.tgz"
  sha256 "a902a9593dff2bd24c3218f98b6d0a7cc511c93db75fa4aeb065c9d485587928"
  license "MIT"
  version_scheme 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ef46d7002eb0c02fdad17b0ab15c831caa0210cee6b26fa1c7e0432a28614d60"
    sha256 cellar: :any,                 arm64_sequoia: "dd268efe0702302ccfb71528f784bde3edd34d050017507e84e3b4b2725b9a8d"
    sha256 cellar: :any,                 arm64_sonoma:  "dd268efe0702302ccfb71528f784bde3edd34d050017507e84e3b4b2725b9a8d"
    sha256 cellar: :any,                 sonoma:        "bb65e9f5e48d3772975c21ec55a9e7e164e569519f2d5ca9b65fb41c3d471936"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "688aeb23a690e7338724b9f9d2514bf23860264494dc8653dcbfddcc1ae77725"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5bba1dedd4005ad3c62ab9e82c318ea08512d0d77fc42dabfb10531a8232a27b"
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
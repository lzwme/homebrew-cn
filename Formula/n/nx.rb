class Nx < Formula
  desc "Smart, Fast and Extensible Build System"
  homepage "https://nx.dev"
  url "https://registry.npmjs.org/nx/-/nx-22.4.5.tgz"
  sha256 "bde6a6e2031ae7fc8ab802cd3ac2d378791ddee9e50b62c4ba88783832460634"
  license "MIT"
  version_scheme 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "debc6de08f63fe233c9e4a2aa52f1776dec22205967f4b4cef1c5e76cab84b71"
    sha256 cellar: :any,                 arm64_sequoia: "6d6073b2e4dcb142acb9f3e542648e61479e01b5bd5bae0a17f9a0c002ccf1e4"
    sha256 cellar: :any,                 arm64_sonoma:  "6d6073b2e4dcb142acb9f3e542648e61479e01b5bd5bae0a17f9a0c002ccf1e4"
    sha256 cellar: :any,                 sonoma:        "b2b05d89a24e96c632df24942592e9e03f2a73f02d27d04ce02c24b3625bcf41"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6317b9dac1ad0180de4e11409d0297bad1878153d29363c99c87f4fd3849f8b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "62e372b612d02f6faccb3875d791eb900fc7284688c3781db3f30b72f9eea31d"
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

    output = shell_output("#{bin}/nx 'test'")
    assert_match "Successfully ran target test", output
  end
end
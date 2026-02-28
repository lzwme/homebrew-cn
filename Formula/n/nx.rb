class Nx < Formula
  desc "Smart, Fast and Extensible Build System"
  homepage "https://nx.dev"
  url "https://registry.npmjs.org/nx/-/nx-22.5.3.tgz"
  sha256 "846eb7142f1e2f3604153e422c4e28b295524c3b681db0e181b78fb2bfa46794"
  license "MIT"
  version_scheme 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d236d1411f732fbb5b3502cef6308b9d8a14662d22fd6d9e5c3424f0fa94e9a1"
    sha256 cellar: :any,                 arm64_sequoia: "9e1e7af4282d6545b4324a1a8d4c33b28fa4bde7d789552e00162a20e5b8040c"
    sha256 cellar: :any,                 arm64_sonoma:  "9e1e7af4282d6545b4324a1a8d4c33b28fa4bde7d789552e00162a20e5b8040c"
    sha256 cellar: :any,                 sonoma:        "e0d1f83f0432dd7e1cf1ed70d6dfb71eabc599a82a4a581281672e3f90e4db3f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7071b94a63e7a4d724c6947a5191d93453080c6b2eadea216ae0ab375e19186a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9012e75f9855e389f5c9439946970f4eb1f593b070507fae4ea2f263b368be71"
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
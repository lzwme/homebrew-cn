class Nx < Formula
  desc "Smart, Fast and Extensible Build System"
  homepage "https://nx.dev"
  url "https://registry.npmjs.org/nx/-/nx-24.0.1.tgz"
  sha256 "a6e40c32b13fa893c9a7e0b532a56c8d32b3cd245edb8771486c45b686f3bbaf"
  license "MIT"
  version_scheme 1

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "5a49c7d972820c9eea71181b71a9c290b2a5b2dd23038849618ebf5463f04945"
    sha256 cellar: :any,                 arm64_tahoe:       "5a49c7d972820c9eea71181b71a9c290b2a5b2dd23038849618ebf5463f04945"
    sha256 cellar: :any,                 arm64_sequoia:     "5a49c7d972820c9eea71181b71a9c290b2a5b2dd23038849618ebf5463f04945"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e589bfe927df4f3b4bd9882131f04a0732ba1686a7789a4e10a6c2092d0ce414"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "331b39d701967d4802c53e287033d15fc6d74cb7a628402b561001cddd003c80"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    # Avoid daemon and plugin worker sockets in the test sandbox.
    ENV["NX_DAEMON"] = "false"
    ENV["NX_ISOLATE_PLUGINS"] = "false"

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
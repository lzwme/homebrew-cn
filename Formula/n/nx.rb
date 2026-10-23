class Nx < Formula
  desc "Smart, Fast and Extensible Build System"
  homepage "https://nx.dev"
  url "https://registry.npmjs.org/nx/-/nx-24.0.0.tgz"
  sha256 "bc67dd9158d050b52015c9d9c75710717be8415ab62b2a891aeefea838d2ada6"
  license "MIT"
  version_scheme 1

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "741afc47966fbe9dd04dccd5746bddc2b4a89639ce1b4865a61b011e5db33781"
    sha256 cellar: :any,                 arm64_tahoe:       "741afc47966fbe9dd04dccd5746bddc2b4a89639ce1b4865a61b011e5db33781"
    sha256 cellar: :any,                 arm64_sequoia:     "741afc47966fbe9dd04dccd5746bddc2b4a89639ce1b4865a61b011e5db33781"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "53f1ad562f20da778280843b2dbf5925cd9077dac6c288c270e5424d7c4a6e2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "f78e9e1fdb9332c80e34ab5478bde35a5c1b4985ed05a2c4aeb161394ee228bb"
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
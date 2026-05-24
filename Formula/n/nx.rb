class Nx < Formula
  desc "Smart, Fast and Extensible Build System"
  homepage "https://nx.dev"
  url "https://registry.npmjs.org/nx/-/nx-22.7.3.tgz"
  sha256 "bd49212317953ed01ba401415108dc50f22d93ce7791d651f4414f638c625d19"
  license "MIT"
  version_scheme 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d959cfd49e5e4a89140e72851c491100e854fd251c8f20029bf8cb064530d241"
    sha256 cellar: :any,                 arm64_sequoia: "8fda8f05fb5e269a2de6f37353faab463c620950f1212b928db1c9c53067e0ec"
    sha256 cellar: :any,                 arm64_sonoma:  "8fda8f05fb5e269a2de6f37353faab463c620950f1212b928db1c9c53067e0ec"
    sha256 cellar: :any,                 sonoma:        "1f2ae7fde77ef4fc045ec519099440e0ce55c38c86e51cb331b1e25e8b50769f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2c0c3248d8e04fc2b5fc3170e93175e1d23decc1ac83a6d71c360f29404aefc8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c63091368c775434829218d776aa4c654ab784a1eeca4a39da7cba6ecce3219d"
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
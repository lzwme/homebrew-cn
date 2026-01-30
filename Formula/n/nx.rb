class Nx < Formula
  desc "Smart, Fast and Extensible Build System"
  homepage "https://nx.dev"
  url "https://registry.npmjs.org/nx/-/nx-22.4.3.tgz"
  sha256 "1b5260ce93959fbc1907e268a1799f610f1126c592977a86d76d485d6522f43f"
  license "MIT"
  version_scheme 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "549e976941b26f040e98786d02f41e829bd0b7257d172ecb0d705521c9fb2dce"
    sha256 cellar: :any,                 arm64_sequoia: "ce1cf2f1779335150c89e6f10baabbccee34323b3ba595f68fa010f9cb833260"
    sha256 cellar: :any,                 arm64_sonoma:  "ce1cf2f1779335150c89e6f10baabbccee34323b3ba595f68fa010f9cb833260"
    sha256 cellar: :any,                 sonoma:        "966075ee4e82e8169b6f7f39db0c6a89d6473d0808ea81fbdc31b2682a6d5c68"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "07d0c4d8a8ff1339ba27956a375380426c169c5b52660d424e56f713508b377d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e68f0a901a436b308b9f7309247b766f6f482fcb45bbd2bf384faca497a2df3e"
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
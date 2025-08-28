class Nx < Formula
  desc "Smart, Fast and Extensible Build System"
  homepage "https://nx.dev"
  url "https://registry.npmjs.org/nx/-/nx-21.4.1.tgz"
  sha256 "c06b9cc57533a08fcd42b83230a5adc1245479827dbe0af3666e9f709ae7a92e"
  license "MIT"
  version_scheme 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8e9239a4398a8e701a08b33721cbe823c1efec4360908c9385f9216d72518a1b"
    sha256 cellar: :any,                 arm64_sonoma:  "8e9239a4398a8e701a08b33721cbe823c1efec4360908c9385f9216d72518a1b"
    sha256 cellar: :any,                 arm64_ventura: "8e9239a4398a8e701a08b33721cbe823c1efec4360908c9385f9216d72518a1b"
    sha256 cellar: :any,                 sonoma:        "3fbdd27944e125a98b0e0863cafb087e5028120b4ad3c3c888e87c23f596cb8a"
    sha256 cellar: :any,                 ventura:       "3fbdd27944e125a98b0e0863cafb087e5028120b4ad3c3c888e87c23f596cb8a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "276510ddd9e28e474990d044bec2e9af9eb00f6966169d121ddc1cc233218bec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a684e73eeb68e24c4970557ae2b6d8a42723f9f2180d36965eeeed57e2a985f3"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
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
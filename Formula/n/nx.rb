class Nx < Formula
  desc "Smart, Fast and Extensible Build System"
  homepage "https://nx.dev"
  url "https://registry.npmjs.org/nx/-/nx-21.3.5.tgz"
  sha256 "437f68aa87a5e7966df0ca84d401799ae0b0b1ab535fd5d2d3d6fc2ad44855d2"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "022bf92eccbcfd9ae70cbaaf63dcd934248542fa521ec82f25ce74183a438158"
    sha256 cellar: :any,                 arm64_sonoma:  "022bf92eccbcfd9ae70cbaaf63dcd934248542fa521ec82f25ce74183a438158"
    sha256 cellar: :any,                 arm64_ventura: "022bf92eccbcfd9ae70cbaaf63dcd934248542fa521ec82f25ce74183a438158"
    sha256 cellar: :any,                 sonoma:        "1e7377c061278ebb049c5fae32fc25ab09217a22b252b0dd56b374652a7c6b95"
    sha256 cellar: :any,                 ventura:       "1e7377c061278ebb049c5fae32fc25ab09217a22b252b0dd56b374652a7c6b95"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "efa43b2141d160f6a0507a6e141000b0738523a28396731726de802e329dbd08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a8ff9ad3e302c26e757c379cbfb7220ecf59963a89cc14ead071027f2191d239"
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
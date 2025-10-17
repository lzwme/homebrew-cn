class Nx < Formula
  desc "Smart, Fast and Extensible Build System"
  homepage "https://nx.dev"
  url "https://registry.npmjs.org/nx/-/nx-21.6.5.tgz"
  sha256 "129cf02ede169234c20d62107f650e3e7825219639318fbd3480b4f22338a32e"
  license "MIT"
  version_scheme 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f9f8c4039d18470dc5e58cf33a737431252104453a88132fb0f8527d81dbbe06"
    sha256 cellar: :any,                 arm64_sequoia: "97498f2ef605238d204269534b0284e7e6709dd4b141420d69cf0e5bd4a32cfc"
    sha256 cellar: :any,                 arm64_sonoma:  "97498f2ef605238d204269534b0284e7e6709dd4b141420d69cf0e5bd4a32cfc"
    sha256 cellar: :any,                 sonoma:        "6eb204b908e30a320d60b1f0ee06c76dd81e8ce3c38e7edecfc714da02a2cab2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3bf1ef0c1273a3745d365b47df3c071e1d2ac91e522b429d0cce6262f525d601"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9318936aba19a97b045dc82f4bcea73fa7be10516a0237b08a3e163ef151d7f7"
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
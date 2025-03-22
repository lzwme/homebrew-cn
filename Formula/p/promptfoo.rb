class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.107.4.tgz"
  sha256 "3c08b8f3fd10ca783691ed2eceaf01379a12cf6edb3ae131ba14094d2808cb6a"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "91b211333712562e6984215a3a91621763dd238049e1517c337c3346d665cc5d"
    sha256 cellar: :any,                 arm64_sonoma:  "f59c22a3bcb98eb001f8c02db9d5e78e9a40e56eeb7fd86f3e939f1bc0ea83d0"
    sha256 cellar: :any,                 arm64_ventura: "42b258efd235835d0dcce5fb7c24a2bf22f94df24e7d4d135339e5deb9196cbd"
    sha256                               sonoma:        "d054d372d3c883f6af3fdb5538bffa2c7323039018adca5e3c61195888118fc0"
    sha256                               ventura:       "53a25a5d18e953dfbe981d21df6cfc4c4f1ece526342f9ed8bb74c5b8bf30869"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0f53b9082c6a943c748a55216d342298604d47d1eb437c03f9a6ace5829114ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "66f324633b5efb8b73e1b1069979a62e6907f0d92f4414c8650c19ba48c0ff3e"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    ENV["PROMPTFOO_DISABLE_TELEMETRY"] = "1"

    system bin/"promptfoo", "init", "--no-interactive"
    assert_path_exists testpath/"promptfooconfig.yaml"
    assert_match "description: \"My eval\"", (testpath/"promptfooconfig.yaml").read

    assert_match version.to_s, shell_output("#{bin}/promptfoo --version")
  end
end
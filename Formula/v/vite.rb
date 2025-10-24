class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-7.1.12.tgz"
  sha256 "85f5144ff94a0ee96ae48b142fb4f26a704381723702c6acd467020d43c657bf"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "26fdfba9571333adf9192d9c8e916268c1e6ecbd8a5da84a4753767d11e8ee84"
    sha256 cellar: :any,                 arm64_sequoia: "3894dc1aaaef38d549694ba2c4c911728823e031d41327ad576c0d73602ee479"
    sha256 cellar: :any,                 arm64_sonoma:  "3894dc1aaaef38d549694ba2c4c911728823e031d41327ad576c0d73602ee479"
    sha256 cellar: :any,                 sonoma:        "9c71f8caae163be8a0b3926843816b010602e96bbba13e1d872f9f30426c91db"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "95d991a81d88ac86c91a91101d4d0ce0ba53e9d1747225a025882c72f2d0a94c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "128b9245a14d19880de9d4be5167a9c1112d1f8ecb333a13409fef65421ee0b8"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/vite optimize --force")
    assert_match "Forced re-optimization of dependencies", output

    output = shell_output("#{bin}/vite optimize")
    assert_match "Hash is consistent. Skipping.", output

    assert_match version.to_s, shell_output("#{bin}/vite --version")
  end
end
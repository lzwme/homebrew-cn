class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-0.13.7.tgz"
  sha256 "329edd3e3ecf592967a501d36e0e7bd74c57b2c17957ec5373ef7fed595e1b1e"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "39beb028b8ab437a5de022e3c5c8c38551c8f2239f9707a7d11803d18d75bce4"
    sha256                               arm64_sequoia: "39beb028b8ab437a5de022e3c5c8c38551c8f2239f9707a7d11803d18d75bce4"
    sha256                               arm64_sonoma:  "39beb028b8ab437a5de022e3c5c8c38551c8f2239f9707a7d11803d18d75bce4"
    sha256 cellar: :any_skip_relocation, sonoma:        "739cc03d4430e14eaa716f422cc0dd1b25a5a9e7276ad4d9af5cf005b69b5cd6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "01fa6fc9f18a26578f048dfc30b4488e80895cd709899b6f94ef792ced2ef3f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0acbf0a05c0e7abeba705139199045fa2e6b9d39c506d33046534372a037c624"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/opencode --version")
    assert_match "opencode", shell_output("#{bin}/opencode models")
  end
end
class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-0.15.14.tgz"
  sha256 "4f5813798c41e6660cf4975f0a7b7b5d34deb561cf56bb9989919332f40b6732"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "ba1f6474b5541ae66fa254e70169dc2faad4c6f83221d4b9e1981d04d64bb7a5"
    sha256                               arm64_sequoia: "ba1f6474b5541ae66fa254e70169dc2faad4c6f83221d4b9e1981d04d64bb7a5"
    sha256                               arm64_sonoma:  "ba1f6474b5541ae66fa254e70169dc2faad4c6f83221d4b9e1981d04d64bb7a5"
    sha256 cellar: :any_skip_relocation, sonoma:        "795004ea2f733dbfd1740cd50653aa6d2f65adc8481f903b76e209f382190cf1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2f22bc3668ed782744ac6d9a8c5aef58f08a68b9447d600e2ea73675a9469365"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d742dd2a82e736efb75643c2e01bf5f20526c79611895508379cc5862ecd0a9d"
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
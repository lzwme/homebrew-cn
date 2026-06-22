class Wuchale < Formula
  desc "Protobuf-like i18n from plain code"
  homepage "https://wuchale.dev/"
  url "https://registry.npmjs.org/wuchale/-/wuchale-0.24.2.tgz"
  sha256 "da78841d10e72b2d4c479b6c3b77f7c1aa92c4df47f0f6a6a7b63438b9bfa7fe"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b17511f69be9a5595b7ae2812a13279b9d81748efc498d6933433ff39b4ad05e"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    (testpath/"wuchale.config.mjs").write <<~EOS
      export default {
        locales: ["en"]
      };
    EOS

    output = shell_output("#{bin}/wuchale --config #{testpath}/wuchale.config.mjs status 2>&1", 1)
    assert_match "at least one adapter is needed.", output
  end
end
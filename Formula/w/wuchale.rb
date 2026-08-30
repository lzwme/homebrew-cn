class Wuchale < Formula
  desc "Protobuf-like i18n from plain code"
  homepage "https://wuchale.dev/"
  url "https://registry.npmjs.org/wuchale/-/wuchale-0.26.2.tgz"
  sha256 "26d4c490eda710ec9af17cfbcf497fd953b8e5f8da0e66c66b64f8f61fff5c0b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "bbcc8bccef0d1ea981780c818cfad9131722e951c4f90b6cd9c7ef2a7ad79340"
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
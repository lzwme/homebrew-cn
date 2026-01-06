class Wuchale < Formula
  desc "Protobuf-like i18n from plain code"
  homepage "https://wuchale.dev/"
  url "https://registry.npmjs.org/wuchale/-/wuchale-0.19.2.tgz"
  sha256 "d2074607a82559262eb03ca1d0cb711a8cfd04fa2a5c15e323bc48fcf1839d35"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ea5672987bce829a8586e66450b61f300a22d602cb6e3e488bf573e248d1c4a7"
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

    output = shell_output("#{bin}/wuchale --config #{testpath}/wuchale.config.mjs status")
    assert_match "Locales: \e[36men (English)\e[0m", output
  end
end
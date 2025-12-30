class Wuchale < Formula
  desc "Protobuf-like i18n from plain code"
  homepage "https://wuchale.dev/"
  url "https://registry.npmjs.org/wuchale/-/wuchale-0.19.0.tgz"
  sha256 "e309caf2afe80831db88aa9cf4dcf6848b5eea32f595585f129b1ea191cc67c4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "75d74e4dfe658ea9d667d086338c0ad8f41afa3870eca437dd35b5579cac7de1"
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
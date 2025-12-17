class Wuchale < Formula
  desc "Protobuf-like i18n from plain code"
  homepage "https://wuchale.dev/"
  url "https://registry.npmjs.org/wuchale/-/wuchale-0.18.8.tgz"
  sha256 "e12e2ad9288c3bea681eaa2660f163dc53a0767694ff1a051efcc9162ad383e9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2aab3da55b68e65ad7d9d65e8c7e1df82c0f301132d482ffee5e731fb389f0c4"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"wuchale.config.mjs").write <<~EOS
      export default {};
    EOS

    system bin/"wuchale", "--config", testpath/"wuchale.config.mjs", "init"
    assert_path_exists testpath/"wuchale.config.mjs"

    output = shell_output("#{bin}/wuchale --config #{testpath}/wuchale.config.mjs status")
    assert_match "Locales: \e[36men (English)\e[0m", output
  end
end
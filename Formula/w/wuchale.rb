class Wuchale < Formula
  desc "Protobuf-like i18n from plain code"
  homepage "https://wuchale.dev/"
  url "https://registry.npmjs.org/wuchale/-/wuchale-0.21.1.tgz"
  sha256 "9397f72958fa6c570e0922761e2a974d581cc8fba22ba4b99bc4d18fe7128609"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b0ca2cd9cbfeaf5e3a80b2d93715e2c239fa3e5f10f78abd1e6fdcd72b4c3f4c"
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
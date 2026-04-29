class Wuchale < Formula
  desc "Protobuf-like i18n from plain code"
  homepage "https://wuchale.dev/"
  url "https://registry.npmjs.org/wuchale/-/wuchale-0.23.2.tgz"
  sha256 "a71c44264c94a22890d6fb7e3fc068a041d677aaa138913d967cd59c5e087a67"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "637b4867c6d66de3f18d294f77260c953ab8e0562fd2c48f7917346281e240a6"
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
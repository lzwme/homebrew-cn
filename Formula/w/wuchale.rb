class Wuchale < Formula
  desc "Protobuf-like i18n from plain code"
  homepage "https://wuchale.dev/"
  url "https://registry.npmjs.org/wuchale/-/wuchale-0.21.0.tgz"
  sha256 "ae2adecaccb6f92ee9501d0fbe0dc9d9b6a71a639956795734db351bec9762aa"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d5acbdc7d85068f999f76bd9cbc7fb376a64f73a41fcd20f764deb088fcce0a6"
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
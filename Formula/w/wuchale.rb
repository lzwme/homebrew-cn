class Wuchale < Formula
  desc "Protobuf-like i18n from plain code"
  homepage "https://wuchale.dev/"
  url "https://registry.npmjs.org/wuchale/-/wuchale-0.22.1.tgz"
  sha256 "ddac10b0c3f83b034d430e117cbab3b110c67b4274ec92cc53141f44b7079641"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6787ff296efa24ccbe363c9d0dc8a684fb2ffb539e887f6928ad496e60c41ec6"
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
class Wuchale < Formula
  desc "Protobuf-like i18n from plain code"
  homepage "https://wuchale.dev/"
  url "https://registry.npmjs.org/wuchale/-/wuchale-0.24.1.tgz"
  sha256 "d47901013374cdecba138fa2ef629279bc6e15b12088100614211f05e1a31749"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e77eb5fd8d4ec951a6557625586979375e3e0d588b8cc5dc19d7b8872ef70dfa"
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
class Wuchale < Formula
  desc "Protobuf-like i18n from plain code"
  homepage "https://wuchale.dev/"
  url "https://registry.npmjs.org/wuchale/-/wuchale-0.25.3.tgz"
  sha256 "969bee5a287d8a7ad7680680ce6371f63b3c5fd5c80058785a4368fefb865c85"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d4e9764196228580410c8fbffa85ccec25a87937aeb0433b3ca649032d4094d8"
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
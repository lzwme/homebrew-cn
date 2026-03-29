class Wuchale < Formula
  desc "Protobuf-like i18n from plain code"
  homepage "https://wuchale.dev/"
  url "https://registry.npmjs.org/wuchale/-/wuchale-0.22.5.tgz"
  sha256 "0284b22d86994b7456ce28048286aa6426788088e1253cfee18d5b4b53220a25"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8cf957186c1a853e60a276da9d40076521941de4421a29cb15eb50066060663e"
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
class Wuchale < Formula
  desc "Protobuf-like i18n from plain code"
  homepage "https://wuchale.dev/"
  url "https://registry.npmjs.org/wuchale/-/wuchale-0.22.8.tgz"
  sha256 "c4a5ce7ceb95c69ac2bdaee0740f11d3fd0e39a97fd6a978d3bcd42b548f4814"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "63adbba30187a2452ed4dd4af38775ad32e7eb6fac6c2deff8ea41ad97bfc5d2"
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
class Wuchale < Formula
  desc "Protobuf-like i18n from plain code"
  homepage "https://wuchale.dev/"
  url "https://registry.npmjs.org/wuchale/-/wuchale-0.22.7.tgz"
  sha256 "b6774d8b576c9ea45da7510c7980dd346955bdea3f9593d1d80aa5fa62758c10"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "fadc9ca7aba1d345e5e3c8aaf29ee18b326fac64cd7003b0a5697f1028330e61"
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
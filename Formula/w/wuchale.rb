class Wuchale < Formula
  desc "Protobuf-like i18n from plain code"
  homepage "https://wuchale.dev/"
  url "https://registry.npmjs.org/wuchale/-/wuchale-0.22.4.tgz"
  sha256 "94f48a75ad284142da2e7dcf147db8073265dd52ac44f9730659b3c60cdb63a3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f1f914f1ef3d46cebf2103c1641394c52e5c3ca811417c8f83a0bc3bbddf4162"
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
class OhdearCli < Formula
  desc "Tool to manage your Oh Dear sites"
  homepage "https://github.com/ohdearapp/ohdear-cli"
  url "https://ghfast.top/https://github.com/ohdearapp/ohdear-cli/releases/download/v5.2.0/ohdear.phar"
  sha256 "ab399d4301a23ebfbfb49a430f0c3caf558919c4549f36c027cf8c89095f2f87"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "260c8c0f9fec6277c36bcaffc3a7c28e6dbef7e2c6bb3255559b8b1f37209591"
  end

  depends_on "php"

  def install
    bin.install "ohdear.phar" => "ohdear"
    # The cli tool was renamed (3.x -> 4.0.0)
    # Create a symlink to not break compatibility
    bin.install_symlink bin/"ohdear" => "ohdear-cli"
  end

  test do
    assert_match "Your API token is invalid or expired.", shell_output("#{bin}/ohdear get-me", 1)
  end
end
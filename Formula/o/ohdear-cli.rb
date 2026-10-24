class OhdearCli < Formula
  desc "Tool to manage your Oh Dear sites"
  homepage "https://ohdear.app"
  url "https://ghfast.top/https://github.com/ohdearapp/ohdear-cli/releases/download/v5.4.1/ohdear.phar"
  sha256 "7385d40d3bba879a6d0029df116c026d496b36943c7d5932fe2711d7745d6b69"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "20b1aac27386853c014fdd986288126f1857bde7b18a2ea5966c34ec613aa09b"
  end

  depends_on "php"

  allow_network_access! :test

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
class OhdearCli < Formula
  desc "Tool to manage your Oh Dear sites"
  homepage "https://github.com/ohdearapp/ohdear-cli"
  url "https://ghfast.top/https://github.com/ohdearapp/ohdear-cli/releases/download/v5.0.0/ohdear.phar"
  sha256 "3a20dba5890edeebb09a62addf654fc41180bcea525fc8eb82802f01ea33870e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "820bb0c739cd2635ed99a13e7f04d20780f2109b37515f33b5b5b87c1881ce4a"
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
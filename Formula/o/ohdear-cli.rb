class OhdearCli < Formula
  desc "Tool to manage your Oh Dear sites"
  homepage "https://github.com/ohdearapp/ohdear-cli"
  url "https://ghfast.top/https://github.com/ohdearapp/ohdear-cli/releases/download/v5.1.1/ohdear.phar"
  sha256 "0f42e4b88b9447936c06ea9999f5820e71e9b9c294963a1f5941ef0b1ae7ebda"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "94a32147dc4c64360a6ba49e7034f41af486e1988d7c4f71e4c6786e2d23d409"
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
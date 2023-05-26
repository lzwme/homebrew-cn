class OhdearCli < Formula
  desc "Tool to manage your Oh Dear sites"
  homepage "https://github.com/ohdearapp/ohdear-cli"
  url "https://ghproxy.com/https://github.com/ohdearapp/ohdear-cli/releases/download/v4.0.0/ohdear.phar"
  sha256 "640a678596ce400cfc31c99de9ab951b25051eb04fcdcc51e38d95f1b6a9410e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f707676c629005335c43208d9d1a98fa1af8163dfc2bf9c8f2cc3606455418b7"
  end

  depends_on "php"

  def install
    bin.install "ohdear.phar" => "ohdear"
    # The cli tool was renamed (3.x -> 4.0.0)
    # Create a symlink to not break compatibility
    bin.install_symlink bin/"ohdear" => "ohdear-cli"
  end

  test do
    assert_match "Unauthorised", shell_output("#{bin}/ohdear me", 1)
  end
end
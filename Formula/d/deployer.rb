class Deployer < Formula
  desc "Deployment tool written in PHP with support for popular frameworks"
  homepage "https://deployer.org/"
  url "https://ghfast.top/https://github.com/deployphp/deployer/releases/download/v8.0.4/deployer.phar"
  sha256 "0c09cfce1cf3b4b49dee3b4288202cb42eb66552f80bf7300e4b6560831c55c8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ea06a2e895fd82d32abf6c9f597591c3898464ec76bc020f1656dbd4cfdc6aac"
  end

  depends_on "php"

  def install
    bin.install "deployer.phar" => "dep"
  end

  test do
    system bin/"dep", "init", "--no-interaction"
    assert_path_exists testpath/"deploy.php"
  end
end
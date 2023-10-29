class Deployer < Formula
  desc "Deployment tool written in PHP with support for popular frameworks"
  homepage "https://deployer.org/"
  url "https://ghproxy.com/https://github.com/deployphp/deployer/releases/download/v7.3.2/deployer.phar"
  sha256 "ed2cd6b685c25e094c30b9cbfccb3b798459c05e4f7df924332a49d80dafbee7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e99a14e01b2aaca3b39223e67f9141339c0b068b3eb5ce7a5bec899903cbb4e3"
  end

  depends_on "php"

  conflicts_with "dep", because: "both install `dep` binaries"

  def install
    bin.install "deployer.phar" => "dep"
  end

  test do
    system "#{bin}/dep", "init", "--no-interaction"
    assert_predicate testpath/"deploy.php", :exist?
  end
end
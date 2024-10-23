class Deployer < Formula
  desc "Deployment tool written in PHP with support for popular frameworks"
  homepage "https:deployer.org"
  url "https:github.comdeployphpdeployerreleasesdownloadv7.5.3deployer.phar"
  sha256 "8f60af206016a42b1d9860b81b537a445863d2b1bddd436d5e70c931645484a3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "29cffc2afb9726fa54f7783888e34451601f801fcdb25312f89f83cd46980f6e"
  end

  depends_on "php"

  def install
    bin.install "deployer.phar" => "dep"
  end

  test do
    system bin"dep", "init", "--no-interaction"
    assert_predicate testpath"deploy.php", :exist?
  end
end
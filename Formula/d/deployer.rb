class Deployer < Formula
  desc "Deployment tool written in PHP with support for popular frameworks"
  homepage "https:deployer.org"
  url "https:github.comdeployphpdeployerreleasesdownloadv7.5.4deployer.phar"
  sha256 "22b7d7063429f2714fcb2ef54ef677a2821eb53e9ce37b70f5fbdb937ba653d4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "eae27cf112e397fa3db5b53b0e02f7421a46a5db7eaa420ae634f554bab9ada4"
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
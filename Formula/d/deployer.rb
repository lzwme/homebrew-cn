class Deployer < Formula
  desc "Deployment tool written in PHP with support for popular frameworks"
  homepage "https:deployer.org"
  url "https:github.comdeployphpdeployerreleasesdownloadv7.5.5deployer.phar"
  sha256 "30c1c09038b0c390f40d21b3cb0a9e1ff46cfeefe4da1c834aeca6adfb5952d4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "bafc1e45e6c3ee51ac93ab5ce78373e6549c1b50c6d6a4cebaa32174b8df3d0d"
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
class OhdearCli < Formula
  desc "Tool to manage your Oh Dear sites"
  homepage "https:github.comohdearappohdear-cli"
  url "https:github.comohdearappohdear-clireleasesdownloadv4.3.1ohdear.phar"
  sha256 "2af752e7e5ba316e696795860c911df2327033ead395645e055c86fc00ae588c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e142196fd160453d6cb57aa083561c73079fb38778ba34152ff19f6b3447933d"
  end

  depends_on "php"

  def install
    bin.install "ohdear.phar" => "ohdear"
    # The cli tool was renamed (3.x -> 4.0.0)
    # Create a symlink to not break compatibility
    bin.install_symlink bin"ohdear" => "ohdear-cli"
  end

  test do
    assert_match "Unauthorised", shell_output("#{bin}ohdear me", 1)
  end
end
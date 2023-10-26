class WpCli < Formula
  desc "Command-line interface for WordPress"
  homepage "https://wp-cli.org/"
  url "https://ghproxy.com/https://github.com/wp-cli/wp-cli/releases/download/v2.9.0/wp-cli-2.9.0.phar"
  sha256 "af6b7ccc21ed0907cb504db5a059f0e120117905a6017bfdd4375cee3c93d864"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7195f7831f27aacbebb92b3daff2c7f5663133383f8d80a6dfdd631faf330995"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7195f7831f27aacbebb92b3daff2c7f5663133383f8d80a6dfdd631faf330995"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7195f7831f27aacbebb92b3daff2c7f5663133383f8d80a6dfdd631faf330995"
    sha256 cellar: :any_skip_relocation, sonoma:         "bc3d13a54b99943771395542bee2629e54117aa5f14759f5826eb7c9884f4c15"
    sha256 cellar: :any_skip_relocation, ventura:        "bc3d13a54b99943771395542bee2629e54117aa5f14759f5826eb7c9884f4c15"
    sha256 cellar: :any_skip_relocation, monterey:       "bc3d13a54b99943771395542bee2629e54117aa5f14759f5826eb7c9884f4c15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7195f7831f27aacbebb92b3daff2c7f5663133383f8d80a6dfdd631faf330995"
  end

  depends_on "php"

  # Keg-relocation breaks the formula when it replaces `/usr/local` with a non-default prefix
  on_macos do
    on_intel do
      pour_bottle? only_if: :default_prefix
    end
  end

  def install
    bin.install "wp-cli-#{version}.phar" => "wp"
  end

  test do
    output = shell_output("#{bin}/wp core download --path=wptest")
    assert_match "Success: WordPress downloaded.", output
  end
end
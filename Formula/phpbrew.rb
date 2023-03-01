class Phpbrew < Formula
  desc "Brew & manage PHP versions in pure PHP at HOME"
  homepage "https://phpbrew.github.io/phpbrew"
  url "https://ghproxy.com/https://github.com/phpbrew/phpbrew/releases/download/2.0.0/phpbrew"
  sha256 "b85d2c7a2bf6cf7ec9173e0db7eb6cf9e6de56589b2d845fdbecc492dd24111a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "03a4ce471cc9c831a38897771691b9e1089210951a6ad6e2722dfb8aa4ffa716"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "03a4ce471cc9c831a38897771691b9e1089210951a6ad6e2722dfb8aa4ffa716"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "03a4ce471cc9c831a38897771691b9e1089210951a6ad6e2722dfb8aa4ffa716"
    sha256 cellar: :any_skip_relocation, ventura:        "5782ecc05e283e4a773cfcdc5d9048e82a85d00f7ceb6a598c2f96e7ae6f0592"
    sha256 cellar: :any_skip_relocation, monterey:       "5782ecc05e283e4a773cfcdc5d9048e82a85d00f7ceb6a598c2f96e7ae6f0592"
    sha256 cellar: :any_skip_relocation, big_sur:        "5782ecc05e283e4a773cfcdc5d9048e82a85d00f7ceb6a598c2f96e7ae6f0592"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "03a4ce471cc9c831a38897771691b9e1089210951a6ad6e2722dfb8aa4ffa716"
  end

  depends_on "php"

  # Keg-relocation breaks the formula when it replaces `/usr/local` with a non-default prefix
  on_macos do
    on_intel do
      pour_bottle? only_if: :default_prefix
    end
  end

  def install
    bin.install "phpbrew"
  end

  test do
    system bin/"phpbrew", "init"
    assert_match "8.0", shell_output("#{bin}/phpbrew known")
  end
end
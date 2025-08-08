class Pie < Formula
  desc "PHP Installer for Extensions"
  homepage "https://github.com/php/pie"
  url "https://ghfast.top/https://github.com/php/pie/releases/download/1.1.0/pie.phar"
  sha256 "36e7d77c38bfca0be0dc2ce9712af1efba06cad0998537fd276b75793f9add1b"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a6d0f318f908bcfce45c353885fd99d2ea80118dcb14a237fb9880a3f6561ce6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a6d0f318f908bcfce45c353885fd99d2ea80118dcb14a237fb9880a3f6561ce6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a6d0f318f908bcfce45c353885fd99d2ea80118dcb14a237fb9880a3f6561ce6"
    sha256 cellar: :any_skip_relocation, sonoma:        "814fd72ae28944837b35b464af3590f11c2339976a5448d7be09287c7189043d"
    sha256 cellar: :any_skip_relocation, ventura:       "814fd72ae28944837b35b464af3590f11c2339976a5448d7be09287c7189043d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "361450fe0243ae79ee9e201d014458ea433a3924822b12f15e551d701cc49543"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "361450fe0243ae79ee9e201d014458ea433a3924822b12f15e551d701cc49543"
  end

  depends_on "php"

  def install
    bin.install "pie.phar" => "pie"
    generate_completions_from_executable("php", bin/"pie", "completion")
  end

  test do
    system bin/"pie", "build", "apcu/apcu"
  end
end
class Pie < Formula
  desc "PHP Installer for Extensions"
  homepage "https:github.comphppie"
  url "https:github.comphppiereleasesdownload0.7.0pie.phar"
  sha256 "17532528ed9ad2bf73443fb908f879fb62b5b467edabc8273924f44e631be4a4"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f78b9881918e9b968e4c5d157cb9e6344138b5c0c43673562267ef248f05940a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f78b9881918e9b968e4c5d157cb9e6344138b5c0c43673562267ef248f05940a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f78b9881918e9b968e4c5d157cb9e6344138b5c0c43673562267ef248f05940a"
    sha256 cellar: :any_skip_relocation, sonoma:        "10535dc5ac2c39282401962050afeac39aceb35f8154d11e5dbcf1866b8c86a4"
    sha256 cellar: :any_skip_relocation, ventura:       "10535dc5ac2c39282401962050afeac39aceb35f8154d11e5dbcf1866b8c86a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b355eae59a1d38597de94aa76733e842d8d2b76f0b549b75d2b592f09770a69a"
  end

  depends_on "php"

  def install
    bin.install "pie.phar" => "pie"
    generate_completions_from_executable("php", bin"pie", "completion")
  end

  test do
    system bin"pie", "build", "apcuapcu"
  end
end
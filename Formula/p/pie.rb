class Pie < Formula
  desc "PHP Installer for Extensions"
  homepage "https://github.com/php/pie"
  url "https://ghfast.top/https://github.com/php/pie/releases/download/1.4.6/pie.phar"
  sha256 "16e1ee2c89735230ee9bf8bf25d616eff2dfe5b8de804b3a335173351faa752c"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ae0c23574ba620e1d281927eb7acf9d76cf5289738e6104ad12e7cda024207b0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ae0c23574ba620e1d281927eb7acf9d76cf5289738e6104ad12e7cda024207b0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ae0c23574ba620e1d281927eb7acf9d76cf5289738e6104ad12e7cda024207b0"
    sha256 cellar: :any_skip_relocation, sonoma:        "7a5da49d05595c68c12ecfd5b14cbc60d348af8628be7a66f3c3facc604de49e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "333cde8bf56556dbea47eac278b0451ba0e8ef7c8d5cda99edbe3cf275156d39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "333cde8bf56556dbea47eac278b0451ba0e8ef7c8d5cda99edbe3cf275156d39"
  end

  depends_on "pkgconf" => :test
  depends_on "re2c" => :test
  depends_on "php"

  def install
    bin.install "pie.phar" => "pie"
    generate_completions_from_executable("php", bin/"pie", "completion")
  end

  test do
    system bin/"pie", "build", "apcu/apcu"
  end
end
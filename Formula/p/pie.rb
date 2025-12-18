class Pie < Formula
  desc "PHP Installer for Extensions"
  homepage "https://github.com/php/pie"
  url "https://ghfast.top/https://github.com/php/pie/releases/download/1.3.2/pie.phar"
  sha256 "3df6dc2d41f654f26f5a1f9d94ff96373090906d9c5e0b42ad7502dcf19908bd"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e5f4097ca785ab16987731d212f5d9135afc4427ff166a03f44172b6b473aaeb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e5f4097ca785ab16987731d212f5d9135afc4427ff166a03f44172b6b473aaeb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e5f4097ca785ab16987731d212f5d9135afc4427ff166a03f44172b6b473aaeb"
    sha256 cellar: :any_skip_relocation, sonoma:        "b76f9a5703399623b7a4a3f79abdaeb5e1d7bb4300a595920e44c21072ad206e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b76f9a5703399623b7a4a3f79abdaeb5e1d7bb4300a595920e44c21072ad206e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b76f9a5703399623b7a4a3f79abdaeb5e1d7bb4300a595920e44c21072ad206e"
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
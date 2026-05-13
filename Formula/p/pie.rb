class Pie < Formula
  desc "PHP Installer for Extensions"
  homepage "https://github.com/php/pie"
  url "https://ghfast.top/https://github.com/php/pie/releases/download/1.4.3/pie.phar"
  sha256 "46e8bf02e580c9f76c8222f310f5edfd7177827131781fae9299453752044712"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "da0d51933999345faa0c92a0da3a36961acf011e3ddbccbb3b37f1b7a9c26fe9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "da0d51933999345faa0c92a0da3a36961acf011e3ddbccbb3b37f1b7a9c26fe9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "da0d51933999345faa0c92a0da3a36961acf011e3ddbccbb3b37f1b7a9c26fe9"
    sha256 cellar: :any_skip_relocation, sonoma:        "5e5d8b6f6fb55d66578ecb401c940027bfbbf47871bfa747558c7243bf0f6e9a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5e5d8b6f6fb55d66578ecb401c940027bfbbf47871bfa747558c7243bf0f6e9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e5d8b6f6fb55d66578ecb401c940027bfbbf47871bfa747558c7243bf0f6e9a"
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
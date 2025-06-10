class Pie < Formula
  desc "PHP Installer for Extensions"
  homepage "https:github.comphppie"
  url "https:github.comphppiereleasesdownload0.13.0pie.phar"
  sha256 "3e741aed185d842278ec9769730e84670a288482d0a837e46c29e482517876c3"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fe156a9f6891356a91f3ae90e535e21c1edcc5a272a7c002a56b71044f49fe14"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fe156a9f6891356a91f3ae90e535e21c1edcc5a272a7c002a56b71044f49fe14"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fe156a9f6891356a91f3ae90e535e21c1edcc5a272a7c002a56b71044f49fe14"
    sha256 cellar: :any_skip_relocation, sonoma:        "578a1cf3ca43c0ec95d1c5c0d22f8e824ec18c1494cc1674ae58e93328777a56"
    sha256 cellar: :any_skip_relocation, ventura:       "578a1cf3ca43c0ec95d1c5c0d22f8e824ec18c1494cc1674ae58e93328777a56"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fd96192b5e3c4df30bf784619c1a12ea041c515a12f58877aada7bcbf73bb8b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd96192b5e3c4df30bf784619c1a12ea041c515a12f58877aada7bcbf73bb8b4"
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
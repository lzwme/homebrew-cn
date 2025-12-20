class Pie < Formula
  desc "PHP Installer for Extensions"
  homepage "https://github.com/php/pie"
  url "https://ghfast.top/https://github.com/php/pie/releases/download/1.3.3/pie.phar"
  sha256 "6f5d8faa24bd2fa6237ea094a9e1342fbb7d4ddd721235d10bb9484b2e514389"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "faac34aedb78a9b5532abcef97f7181b58cbda0023a806defa6c29d0c29c8a4f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "faac34aedb78a9b5532abcef97f7181b58cbda0023a806defa6c29d0c29c8a4f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "faac34aedb78a9b5532abcef97f7181b58cbda0023a806defa6c29d0c29c8a4f"
    sha256 cellar: :any_skip_relocation, sonoma:        "c19e2f9f40dcee21262534fca79c5afa4b2532a5f67bb299c3199e452a7f08d6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c19e2f9f40dcee21262534fca79c5afa4b2532a5f67bb299c3199e452a7f08d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c19e2f9f40dcee21262534fca79c5afa4b2532a5f67bb299c3199e452a7f08d6"
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
class PayloadDumperGo < Formula
  desc "Android OTA payload dumper written in Go"
  homepage "https:github.comssutpayload-dumper-go"
  url "https:github.comssutpayload-dumper-goarchiverefstags1.2.2.tar.gz"
  sha256 "7f80f6c29ad8b835d71f361ba073988a27a33043acec37eea9d9430c1fb04b57"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "0bfc3c97eee0d98c057f01c4c385e41d509ddf652d3af6fd2ffbe4180671e165"
    sha256 cellar: :any,                 arm64_sonoma:   "2ab52724e453a1251da160820b365beffcdb4cb3d6dd33181a8ee2d38acf46f6"
    sha256 cellar: :any,                 arm64_ventura:  "25c0c53def464b6cceea25fa70841e56d0b9e11f3f52101443bd6032bf6958e0"
    sha256 cellar: :any,                 arm64_monterey: "8f6b5106876e00cf046896bd48778bf29ad23f2455ff22bc005a5f4fa65c5353"
    sha256 cellar: :any,                 arm64_big_sur:  "e984276e0f8c673ff3a588abdb8d1827c5363e7b6f466f9c3bf9988faf14ac98"
    sha256 cellar: :any,                 sonoma:         "baec370066bf48118081ec453d86d81b8ae3af4c79404e4d7b91f717da3b1f4c"
    sha256 cellar: :any,                 ventura:        "aafd84e1b6bcd30deb07394dd19e21061cac41d80d6282e2354a1057011badb4"
    sha256 cellar: :any,                 monterey:       "63bce864ece6c9de7ca76aaf563f75be05ac778d660567aa4fd2e98ceb5bc66b"
    sha256 cellar: :any,                 big_sur:        "a6c501425739d78e279399cdbe86589ebb8ba0ff564d07aa7849b65ef93cba9e"
    sha256 cellar: :any,                 catalina:       "3bf1b40363c257f4d2c761940ade539aac4e0936a2f977d4cd34bd0ac2d8da59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "914db99626b3362a7ff898f96b91b038ea02382b44aeff589ce3e265045dd4f4"
  end

  depends_on "go" => :build
  depends_on "xz"

  def install
    system "go", "build", *std_go_args
  end

  test do
    require "base64"

    (testpath"payload.bin").write ::Base64.decode64 <<~EOS
      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
    EOS
    assert_match(Payload Version: 2, shell_output("#{bin}payload-dumper-go -l payload.bin"))
  end
end
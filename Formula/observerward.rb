class Observerward < Formula
  desc "Cross platform community web fingerprint identification tool"
  homepage "https://0x727.github.io/ObserverWard/"
  url "https://ghproxy.com/https://github.com/0x727/ObserverWard/archive/refs/tags/v2023.5.19.tar.gz"
  sha256 "936573fd7be0ebb39b0986643846f3d271b267019aaceb418b4b9dbb694118a8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "680dee189f26f0476cef0ffb6bade07430c2b5dccaa2bf710fb9b679f401cbdc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9cc0dac4710fd7c2b75efc07aa653fe08af0a7c51b25269dbd2ae55fe60497c3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f97910d68be773eb3738908105a75a45986838fe5cc982593a1cb63af23dbaaa"
    sha256 cellar: :any_skip_relocation, ventura:        "f89fb0bcc8a8ee08a6b115db2c3e22907b7e4f9bc8bac2347d0100f893312835"
    sha256 cellar: :any_skip_relocation, monterey:       "02a67e04904b17ec1d539d044e0bc2d5277807af67323849c9679391ec3ba2cb"
    sha256 cellar: :any_skip_relocation, big_sur:        "9b5d89cc2411767c8bc3a31e077e58f561826073a0ac159b708e3d47a4930253"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff0380503ee743ec6be3ac3e59a07c83505935aaf69b7889e7389379569ac434"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"observer_ward", "-u"
    assert_match "0example", shell_output("#{bin}/observer_ward -t https://www.example.com/")
  end
end
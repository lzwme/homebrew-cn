class TelegramDownloader < Formula
  desc "Telegram Messenger downloader/tools written in Golang"
  homepage "https://github.com/iyear/tdl"
  url "https://ghproxy.com/https://github.com/iyear/tdl/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "415ceeb7b2ab2e3627c9064275a7e0fd5c42200c2f12bfe09d0703d650747c0d"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "11d9143c7e9c3fe07504f0889e0328af56819d3ed941ebc2d5734cf972db09bf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "39a0a149545d34c5985625827e66b73d71abcb1a1158beaef7a9c771135efc66"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d10884e3ed7784bb0679863dc527cb2e25ff27a18495859ecb7bea9c7ef50b04"
    sha256 cellar: :any_skip_relocation, sonoma:         "f791e2639353064462b8a1a73d59bcf87ad2d05e07c13498e77fea0642b27f80"
    sha256 cellar: :any_skip_relocation, ventura:        "beacb4bc9c232234c90357550abd2217234f7754a42a0777de0dcf4c59a88365"
    sha256 cellar: :any_skip_relocation, monterey:       "ee3164158c89aa1c8ca69edb2d2ebbaeb40b7bbb66f78127dcec9931df5e59d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "33da068fc9f9a734e9eccfb2999c8818eafd47993f8026829a2d6123911c7373"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"tdl")
  end

  test do
    assert_match "# ID of dialog", shell_output("#{bin}/tdl chat ls -f -")
    assert_match "callback: not authorized. please login first", shell_output("#{bin}/tdl chat ls -n _test", 1)
  end
end
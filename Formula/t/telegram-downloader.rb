class TelegramDownloader < Formula
  desc "Telegram Messenger downloader/tools written in Golang"
  homepage "https://github.com/iyear/tdl"
  url "https://ghproxy.com/https://github.com/iyear/tdl/archive/refs/tags/v0.12.1.tar.gz"
  sha256 "09229d333db613ce55155125b04f1e3269113586dca10b5e24d47450fc73f4ae"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9b92bb4ec0408e4a99130b22457ced29a59784b3b67002381ea416886b818d33"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6c1bf951666495aca39f1fe649baa7884871551f31ebee62aca3c8d450518153"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a59169188e29fce7fea87f051ad1524922273bcb638851dc9eaa56037768f542"
    sha256 cellar: :any_skip_relocation, sonoma:         "9088a27b96d9d358f50c94f2ad200b5133d32deb2a688782043626a375f7f6ca"
    sha256 cellar: :any_skip_relocation, ventura:        "8acb5b09e2f8de050827450c4afa6bc3da3ed91574406fd2ee7b34f3f7e23db9"
    sha256 cellar: :any_skip_relocation, monterey:       "60eafac40ce972de7bf4f0cf1b13450162637a41584ec4409a38f0f2d7d04f8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e36272c7dc86c3bf6d208a107e057058bd07d7298368c66d9cfac02543a43212"
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
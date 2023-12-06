class TelegramDownloader < Formula
  desc "Telegram Messenger downloader/tools written in Golang"
  homepage "https://github.com/iyear/tdl"
  url "https://ghproxy.com/https://github.com/iyear/tdl/archive/refs/tags/v0.13.1.tar.gz"
  sha256 "ad2b8e5b930bfd9b985fb4739ceeeadabd7e3a1cf7fc999c55f782076d6ef574"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f05e2900f553b74c8c169396ff78225071b6f273c7b91672a3233ab290370c00"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "42b1720ac8d56a2abb8f9cbf35d03f428a92e106d17ec4b1fcbe5fd36f41ae3c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1e23da5ac25d7c2b55b28b71077cbde65b09adbfe629ac8c38fc5ecf74d64ab0"
    sha256 cellar: :any_skip_relocation, sonoma:         "924ac09947782152b1b6dba75971fe3132196ed2b214f986c3ff4a7555090b7a"
    sha256 cellar: :any_skip_relocation, ventura:        "1481694d07e426802094c6d4b4bf4fd9b36bc9c3ce70698f1d3b07130bc4144c"
    sha256 cellar: :any_skip_relocation, monterey:       "549c86519f481389688f3540c4c684eb1335ad6d6b82699fb2db86c9ccc30cc8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d6a494cf667ebabdce0a0b2d2deb03678e152111ee5de6e266c11c73162e858a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"tdl")
  end

  test do
    assert_match "# ID of dialog", shell_output("#{bin}/tdl chat ls -f -")
    assert_match "not authorized. please login first", shell_output("#{bin}/tdl chat ls -n _test", 1)
  end
end
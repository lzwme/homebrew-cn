class TelegramDownloader < Formula
  desc "Telegram Messenger downloadertools written in Golang"
  homepage "https:github.comiyeartdl"
  url "https:github.comiyeartdlarchiverefstagsv0.13.3.tar.gz"
  sha256 "f92356bbc29a98bdcbd5bf2ae9c71280cf9d3a577ef0ca3f490a4cbc22739078"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "124d737f12b58c4756de599b304d12320fc03dd7738c8282c4f747034b674c78"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1cdb258291ec324e6cf0d2478b62b794bf7e8785c8408b32ff33aa745bcb7673"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "24706030227e9e9de6bbea2802cace1f40878a9e466d3fe6660b65a6b7e15daf"
    sha256 cellar: :any_skip_relocation, sonoma:         "7eea9c37909b139848191f1a62be0fe611fb114b8887c0bc7908e1d88865fe43"
    sha256 cellar: :any_skip_relocation, ventura:        "e75981ad46043b0d3f152f4d06f3ac4bca5df29a0235de674d66a76ce3062b7c"
    sha256 cellar: :any_skip_relocation, monterey:       "cce939b3b124015b0b9d86da0da26477fb2f7e78e76b48b4d18bb5facf0bcf95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7598f5b5398b8094f6ceaa5d460a2b17c87049d36b4d12f4afacfd9d59ec2ae3"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin"tdl")
  end

  test do
    assert_match "# ID of dialog", shell_output("#{bin}tdl chat ls -f -")
    assert_match "not authorized. please login first", shell_output("#{bin}tdl chat ls -n _test", 1)
  end
end
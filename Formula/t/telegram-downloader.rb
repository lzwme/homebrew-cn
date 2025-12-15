class TelegramDownloader < Formula
  desc "Telegram Messenger downloader/tools written in Golang"
  homepage "https://docs.iyear.me/tdl/"
  url "https://ghfast.top/https://github.com/iyear/tdl/archive/refs/tags/v0.20.1.tar.gz"
  sha256 "dcb6c3d2b41c3712c75dc8f3d69cdc3b932ef9a288e7808df74617af5b487af5"
  license "AGPL-3.0-only"
  head "https://github.com/iyear/tdl.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "780c93680586b74f886751c9d823ac83bc4a124671410ed026877b588c493b59"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "331a7bb6f28f0783acbb5b095fb754d70d9445ab66d8c27fd8c6949ad2958ad1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3dad4b97c6508fb991f67660d9d21755dfa21a1dc30980ffb6ff62068d444fa3"
    sha256 cellar: :any_skip_relocation, sonoma:        "cc2be43a6c19e20249b390dadc3dbda44832b42c77100b3d679684a45d277f7b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "54a097d110bd99e5887bb7415c58ce21e61ac678ee7fb8a26c62140f1c770e53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46eb0034b1ad2b4ba6edd7da8c6e248572dcf79beee18884ab6d70c1e639edef"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/iyear/tdl/pkg/consts.Version=#{version}
      -X github.com/iyear/tdl/pkg/consts.Commit=#{tap.user}
      -X github.com/iyear/tdl/pkg/consts.CommitDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"tdl")

    generate_completions_from_executable(bin/"tdl", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tdl version")

    assert_match "not authorized. please login first", shell_output("#{bin}/tdl chat ls -n _test", 1)
  end
end
class TelegramDownloader < Formula
  desc "Telegram Messenger downloadertools written in Golang"
  homepage "https:docs.iyear.metdl"
  url "https:github.comiyeartdlarchiverefstagsv0.18.4.tar.gz"
  sha256 "55df446ef69ede011fc56361ab17afc061dc85a48effd1c14a23ff505a7266df"
  license "AGPL-3.0-only"
  head "https:github.comiyeartdl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "27f0b4784425b1d80297690a367096f590ff6ec84730c65f2eae7a6bd5cb7a27"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6293a6b13a6cf762f4d87c316f33f730eb810f6f7c0c7ccb6765845d99d88b27"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0aa0fbb1c880c7c155f7e240b5bbbde04639ad4bb31f831483457dbb285c6427"
    sha256 cellar: :any_skip_relocation, sonoma:        "28078f205eeabd3b3a405332f59249f3444c5582597f3830d6519eda778d0feb"
    sha256 cellar: :any_skip_relocation, ventura:       "40188b856d395e638e51e86ee38854561062ccfb6595dc9a340d9244c7ce2488"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "db80fdf6bacb8753fb72919bf76f98078e5fade6485291e59e992b7a37f9ccf3"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comiyeartdlpkgconsts.Version=#{version}
      -X github.comiyeartdlpkgconsts.Commit=#{tap.user}
      -X github.comiyeartdlpkgconsts.CommitDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin"tdl")

    generate_completions_from_executable(bin"tdl", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}tdl version")

    assert_match "not authorized. please login first", shell_output("#{bin}tdl chat ls -n _test", 1)
  end
end
class TelegramDownloader < Formula
  desc "Telegram Messenger downloadertools written in Golang"
  homepage "https:docs.iyear.metdl"
  url "https:github.comiyeartdlarchiverefstagsv0.17.2.tar.gz"
  sha256 "79b171fead97b26ab5b4b643a20a236d634eed46dbcf85cc55ec28ff190a27ea"
  license "AGPL-3.0-only"
  head "https:github.comiyeartdl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fc2cb22b448c8bd3ccd91532d51afb850a390a9aecaf29fff097d84e5feda230"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5f5b0320da17fc2d1d72a00ea1de8ac363915d3a35d34101347bc489c513ed79"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5d5747a486febc3c96f08a543a3c3eabbdedd24e3067dc23361d1c7ec98e1c2d"
    sha256 cellar: :any_skip_relocation, sonoma:         "8c4bfda008b16b6c3e64ee882c25574f91adad70db8f92810ea3e35bf9046cba"
    sha256 cellar: :any_skip_relocation, ventura:        "403f49525672aa535f3fa99a0d8090b2d2a1d8879006a9f97ed31fe34519ac36"
    sha256 cellar: :any_skip_relocation, monterey:       "2ec8b13cb9700525703757b7739f8b8e6a356dc8da41bb57c4b6fdeb39777392"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "16719d3befc102aae30f4c9ca88ff7dfdc518b46728379dbceb6281ca29ba976"
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
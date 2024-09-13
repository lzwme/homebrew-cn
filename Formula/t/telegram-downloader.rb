class TelegramDownloader < Formula
  desc "Telegram Messenger downloadertools written in Golang"
  homepage "https:docs.iyear.metdl"
  url "https:github.comiyeartdlarchiverefstagsv0.17.4.tar.gz"
  sha256 "c3f7fa6e8f5067a0de75df28f8a34bee7a3e586ece6f912cf335bc04ef7ee85b"
  license "AGPL-3.0-only"
  head "https:github.comiyeartdl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "c8f70ee5eac6694e75beb75b8bcef7c859e509944c603ce7ce9c6042ceba130c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0f9247f52e6a8607094097df4291a7f738eb3b2f83cea844d93c8d6b77ac8851"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1922d1d5823ed2e3ce145f737f628d4c1d75deaa5996945bf3179d5f773801bc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f9e05fced8a3545d4ea40436b623261c16bfeea5147cac270153b87582161662"
    sha256 cellar: :any_skip_relocation, sonoma:         "3e538a42f6da2e07d28c357994ef07ee30d2556e2925b2caf53f1cd23e781423"
    sha256 cellar: :any_skip_relocation, ventura:        "d3a9894e955817c3cd10d4c9a143b58f9d065b6540768dcfc8708af958837fe3"
    sha256 cellar: :any_skip_relocation, monterey:       "5a993f249027e756f44391b9d31477981b2b524b507035eb38bc8b0667babc43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "310e219cf515ff1efe3c30cf267964c6ca07cac7ea21eab8451ada99ca0fceef"
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
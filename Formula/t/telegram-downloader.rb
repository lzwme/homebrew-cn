class TelegramDownloader < Formula
  desc "Telegram Messenger downloadertools written in Golang"
  homepage "https:docs.iyear.metdl"
  url "https:github.comiyeartdlarchiverefstagsv0.18.1.tar.gz"
  sha256 "51ea0801c765e0f21394c9af672efa5a9db53c8ddd890db20f0ae18a4718ce01"
  license "AGPL-3.0-only"
  head "https:github.comiyeartdl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c841a516f8fe5c6f874d8ea673e7a78cc540c83e5018a65eab9ad121c8c0d140"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7ff5e3e9aeadb8be9af4daacc40fefec2b22ad0f697b887192321378be756f07"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "742106a330e9bdfa9a6dfd0ae4800a5bb3d0adf3666737e3e207f5a71955fdd0"
    sha256 cellar: :any_skip_relocation, sonoma:        "b0caeed3f1cc4642ad358733427709e81359ed117724f524921a4f5783699243"
    sha256 cellar: :any_skip_relocation, ventura:       "de312f3e9dfc3d5563fc6007903fb63a4318ee5d779fe8f69e6666794f7527df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "abd8690d8fd3b2e6d5a501c2d301bd149510ab1cabb363e1b1cc1d71befdafef"
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
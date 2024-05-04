class Mods < Formula
  desc "AI on the command-line"
  homepage "https:github.comcharmbraceletmods"
  url "https:github.comcharmbraceletmodsarchiverefstagsv1.3.0.tar.gz"
  sha256 "b829a66bce475823406bcd22c577d55c79b5e0add0c36389553539cb7c2ff4d0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c18ea7fa9d325c8bf56e6fe1606168c1b30245cae62ba0ba75f96c91a985f21b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ffcb1a74c6397a296d016e7caa6f6db3fc9e95ea63f2f388fd5a355de62d5bfd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fff39f75d75207176ea7c23a16c79fc42ae3cfe39bf88a78312552c573d24290"
    sha256 cellar: :any_skip_relocation, sonoma:         "63005030a973082c93bcbc6e3c3ac9fa8b79e002cbf35510175f598be4d796e0"
    sha256 cellar: :any_skip_relocation, ventura:        "5e66547d770ee690156d5faa35ecb48c7a6893e4694a1e3c95d6e61dd6fc090d"
    sha256 cellar: :any_skip_relocation, monterey:       "c3cc1d3febf96df8a02675f81b6f72de009a2a28514cc512c9f8afbd7af6517a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5ec09fa23cc3136f3b7cc1235ac769ca23c119fe9a2308305aa5f7a2295c5887"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.Version=#{version}
      -X main.CommitSHA=#{tap.user}
      -X main.CommitDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    ENV["OPENAI_API_KEY"] = "faketest"

    output = pipe_output(bin"mods 2>&1", "Hello, Homebrew!", 1)
    assert_match "ERROR  Invalid openai API key", output

    assert_match version.to_s, shell_output(bin"mods --version")
  end
end
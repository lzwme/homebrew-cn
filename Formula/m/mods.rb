class Mods < Formula
  desc "AI on the command-line"
  homepage "https:github.comcharmbraceletmods"
  url "https:github.comcharmbraceletmodsarchiverefstagsv1.6.0.tar.gz"
  sha256 "885388ac0e55ecec92648b721baf5d392e33f146cf5b92f9f23f365d9746cc07"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e545698222cb6a973edd3e8631a495d026909752b4516d8db7d149654ce8680e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e545698222cb6a973edd3e8631a495d026909752b4516d8db7d149654ce8680e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e545698222cb6a973edd3e8631a495d026909752b4516d8db7d149654ce8680e"
    sha256 cellar: :any_skip_relocation, sonoma:        "01084d35b89c52a6a1bbf88f18fe966a073086f6e9911fbb2b7a08ffc6214aba"
    sha256 cellar: :any_skip_relocation, ventura:       "01084d35b89c52a6a1bbf88f18fe966a073086f6e9911fbb2b7a08ffc6214aba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c44a335db22b0afe82e7d4f476b1cedac8bb10638b8260d136a4d3aa8f5fbe28"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version} -X main.CommitSHA=#{tap.user} -X main.CommitDate=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin"mods", "completion")
  end

  test do
    ENV["OPENAI_API_KEY"] = "faketest"

    output = pipe_output(bin"mods 2>&1", "Hello, Homebrew!", 1)
    assert_match "ERROR  Invalid openai API key", output

    assert_match version.to_s, shell_output(bin"mods --version")
  end
end
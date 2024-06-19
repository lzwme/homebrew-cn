class Mods < Formula
  desc "AI on the command-line"
  homepage "https:github.comcharmbraceletmods"
  url "https:github.comcharmbraceletmodsarchiverefstagsv1.4.1.tar.gz"
  sha256 "93a439af9c823931e62b5eb8aeaa3ab4ea4aa4990c4c4f9ef35d6def9b859b4b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a0eb8b344180d577b26937716125f6cfec2d0924ff17fc787161fbadf8cebd97"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "98d75b23ebbed051b8291a27e56c0462f41c03ac5b0c44cef84fb96bc262250f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0f87db0a3e2fb7e28d71e77d312a82bb023de667dc41e5cb4ae1be8347c5057e"
    sha256 cellar: :any_skip_relocation, sonoma:         "c31d280544806134dc812a6399f6a318ed54ad89f83ca1e45171e71ac0620b25"
    sha256 cellar: :any_skip_relocation, ventura:        "3a01794e48cdb3fb76d98ee1e6e23657ac94b6cc9129f13db3a0d8cf1e559bca"
    sha256 cellar: :any_skip_relocation, monterey:       "8572239f9a8fad43729b75b0cae98f6ef283bc8d0fe82a55785e18c62c6d6443"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "26b342c1afe53e21914e2a9a01d52e648f939f5959370a53f220b821b655d53b"
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
class Runme < Formula
  desc "Execute commands inside your runbooks, docs, and READMEs"
  homepage "https://runme.dev/"
  url "https://ghfast.top/https://github.com/runmedev/runme/archive/refs/tags/v3.15.0.tar.gz"
  sha256 "96a6ac46a27f0a56f2968bf929fa9421a902c62d45aeaf8c8a7a5bfcc5fa3b5d"
  license "Apache-2.0"
  head "https://github.com/runmedev/runme.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2c4b0d348772943851ffcf65c9c309e42e904fa7ddaf151a950a157a098ec941"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2c4b0d348772943851ffcf65c9c309e42e904fa7ddaf151a950a157a098ec941"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2c4b0d348772943851ffcf65c9c309e42e904fa7ddaf151a950a157a098ec941"
    sha256 cellar: :any_skip_relocation, sonoma:        "dd8d474647f54cf790cee6193195d1d6e5711f91bd21873e2f10f49cb0e286c8"
    sha256 cellar: :any_skip_relocation, ventura:       "dd8d474647f54cf790cee6193195d1d6e5711f91bd21873e2f10f49cb0e286c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "74e4425817757f874f44f384e8fbe2320336008fa23a125c5092d819128eb609"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/runmedev/runme/v3/internal/version.BuildDate=#{time.iso8601}
      -X github.com/runmedev/runme/v3/internal/version.BuildVersion=#{version}
      -X github.com/runmedev/runme/v3/internal/version.Commit=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable(bin/"runme", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/runme --version")
    markdown = (testpath/"README.md")
    markdown.write <<~MARKDOWN
      # Some Markdown

      Has some text.

      ```sh { name=foobar }
      echo "Hello World"
      ```
    MARKDOWN
    assert_match "Hello World", shell_output("#{bin}/runme run --git-ignore=false foobar")
    assert_match "foobar", shell_output("#{bin}/runme list --git-ignore=false")
  end
end
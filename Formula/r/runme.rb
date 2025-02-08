class Runme < Formula
  desc "Execute commands inside your runbooks, docs, and READMEs"
  homepage "https:runme.dev"
  url "https:github.comstatefulrunmearchiverefstagsv3.11.1.tar.gz"
  sha256 "57734f897494d6f4ec53973ecebf24fbc18bf450b8a4a4c74510eb5373d2ea53"
  license "Apache-2.0"
  head "https:github.comstatefulrunme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "983ce9e677d315ffda0f11129a09bf2851efd3334dac69ebb65cc5c6f819d625"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "983ce9e677d315ffda0f11129a09bf2851efd3334dac69ebb65cc5c6f819d625"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "983ce9e677d315ffda0f11129a09bf2851efd3334dac69ebb65cc5c6f819d625"
    sha256 cellar: :any_skip_relocation, sonoma:        "043a682b1be21d940a1fb4d8ad99be3c532e717d33729ae9b2c0a367ecbfcb69"
    sha256 cellar: :any_skip_relocation, ventura:       "043a682b1be21d940a1fb4d8ad99be3c532e717d33729ae9b2c0a367ecbfcb69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2536cb794deeaafa366e4bfc28cd35f08f9fa0183d2afd68e8c528024814445c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comstatefulrunmev3internalversion.BuildDate=#{time.iso8601}
      -X github.comstatefulrunmev3internalversion.BuildVersion=#{version}
      -X github.comstatefulrunmev3internalversion.Commit=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable(bin"runme", "completion")
  end

  test do
    system bin"runme", "--version"
    markdown = (testpath"README.md")
    markdown.write <<~MARKDOWN
      # Some Markdown

      Has some text.

      ```sh { name=foobar }
      echo "Hello World"
      ```
    MARKDOWN
    assert_match "Hello World", shell_output("#{bin}runme run --git-ignore=false foobar")
    assert_match "foobar", shell_output("#{bin}runme list --git-ignore=false")
  end
end
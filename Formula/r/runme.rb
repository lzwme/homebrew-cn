class Runme < Formula
  desc "Execute commands inside your runbooks, docs, and READMEs"
  homepage "https:runme.dev"
  url "https:github.comstatefulrunmearchiverefstagsv3.10.1.tar.gz"
  sha256 "c74eafe92911170d70d44cc7b6c9b3f95a68fb690858f4c460211f4a2727bca7"
  license "Apache-2.0"
  head "https:github.comstatefulrunme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6dfa8a1e80e730a1493f883a6f010e0d3451d45c2924546e9d1acdcb7fd553eb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6dfa8a1e80e730a1493f883a6f010e0d3451d45c2924546e9d1acdcb7fd553eb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6dfa8a1e80e730a1493f883a6f010e0d3451d45c2924546e9d1acdcb7fd553eb"
    sha256 cellar: :any_skip_relocation, sonoma:        "48b3aac997042131195bc21d97a19b0874c49bf3c091113bf9ee97e8c13d9bd3"
    sha256 cellar: :any_skip_relocation, ventura:       "48b3aac997042131195bc21d97a19b0874c49bf3c091113bf9ee97e8c13d9bd3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cfaa2a613c1ede493e82ceaa0523ab65a4bce0c85158fdce8eed58c8b62112a1"
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
class Runme < Formula
  desc "Execute commands inside your runbooks, docs, and READMEs"
  homepage "https:runme.dev"
  url "https:github.comstatefulrunmearchiverefstagsv3.8.3.tar.gz"
  sha256 "f94cdfdf68c363378046876f45c9284952bdc4f78510928c9dad427c4bf41510"
  license "Apache-2.0"
  head "https:github.comstatefulrunme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c6f7daa3f0312c81cf23543fae014a999e0a18f76ce72f45c5f65b57e6518559"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c6f7daa3f0312c81cf23543fae014a999e0a18f76ce72f45c5f65b57e6518559"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c6f7daa3f0312c81cf23543fae014a999e0a18f76ce72f45c5f65b57e6518559"
    sha256 cellar: :any_skip_relocation, sonoma:        "0c163f52bbc175b4531b04d8676b5bc869c10b81e5be2cb98a7c13063324accb"
    sha256 cellar: :any_skip_relocation, ventura:       "0c163f52bbc175b4531b04d8676b5bc869c10b81e5be2cb98a7c13063324accb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8bb7aa33dec491c4de89db32ade05465f7d496fd4f1ed3585b3e73b0eb66064d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comstatefulrunmev3internalversion.BuildDate=#{time.iso8601}
      -X github.comstatefulrunmev3internalversion.BuildVersion=#{version}
      -X github.comstatefulrunmev3internalversion.Commit=#{tap.user}
    ]

    system "go", "build", "-o", bin, *std_go_args(ldflags:)
    generate_completions_from_executable(bin"runme", "completion")
  end

  test do
    system bin"runme", "--version"
    markdown = (testpath"README.md")
    markdown.write <<~EOS
      # Some Markdown

      Has some text.

      ```sh { name=foobar }
      echo "Hello World"
      ```
    EOS
    assert_match "Hello World", shell_output("#{bin}runme run --git-ignore=false foobar")
    assert_match "foobar", shell_output("#{bin}runme list --git-ignore=false")
  end
end
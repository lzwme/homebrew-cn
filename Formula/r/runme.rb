class Runme < Formula
  desc "Execute commands inside your runbooks, docs, and READMEs"
  homepage "https:runme.dev"
  url "https:github.comstatefulrunmearchiverefstagsv3.12.3.tar.gz"
  sha256 "48e5ce1ec40f2426fda256c2bceebd3b7624aa5562ce8561ec389505d8db119b"
  license "Apache-2.0"
  head "https:github.comstatefulrunme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a94a5935d4e224a82629137a6e7f4733c5af6ce0704eb653873b5262c3e1b66f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a94a5935d4e224a82629137a6e7f4733c5af6ce0704eb653873b5262c3e1b66f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a94a5935d4e224a82629137a6e7f4733c5af6ce0704eb653873b5262c3e1b66f"
    sha256 cellar: :any_skip_relocation, sonoma:        "f2eae784fe2b57329fc50444876c9c0625940b5abe0ae99d92b2dc4c5e695af7"
    sha256 cellar: :any_skip_relocation, ventura:       "f2eae784fe2b57329fc50444876c9c0625940b5abe0ae99d92b2dc4c5e695af7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c7c8bd9c038a58611ddfbac521e27ff927bd2042dc8bd6fc5e53239a49854d3"
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
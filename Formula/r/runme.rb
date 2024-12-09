class Runme < Formula
  desc "Execute commands inside your runbooks, docs, and READMEs"
  homepage "https:runme.dev"
  url "https:github.comstatefulrunmearchiverefstagsv3.10.0.tar.gz"
  sha256 "aac77a3c64c8c7bfc3c97d8a71acc8d64d6a5124c83aabf5f0ad5540621738a1"
  license "Apache-2.0"
  head "https:github.comstatefulrunme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eba284cd63a628d7e0ae147a77f5293f7b966cd9fe7090ff7f0bfcb0f79d99ec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eba284cd63a628d7e0ae147a77f5293f7b966cd9fe7090ff7f0bfcb0f79d99ec"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "eba284cd63a628d7e0ae147a77f5293f7b966cd9fe7090ff7f0bfcb0f79d99ec"
    sha256 cellar: :any_skip_relocation, sonoma:        "14b41cd8e301aa2fe89e0361ac3b5f2735455cbf0d91f0222ec6c9594ce30b00"
    sha256 cellar: :any_skip_relocation, ventura:       "14b41cd8e301aa2fe89e0361ac3b5f2735455cbf0d91f0222ec6c9594ce30b00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a36ffd2d42e11ae2e758c0893155eb302344bb400c3a35f6a1d845129ccfd274"
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
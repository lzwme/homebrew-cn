class Runme < Formula
  desc "Execute commands inside your runbooks, docs, and READMEs"
  homepage "https:runme.dev"
  url "https:github.comstatefulrunmearchiverefstagsv3.12.6.tar.gz"
  sha256 "d9fcf33883ccf0eaa7cc3e65bb6c6c3a52b9279df46ff0544e49cb5a1ce49227"
  license "Apache-2.0"
  head "https:github.comstatefulrunme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6a2f727d5c5212142503a889f57ad43376ac07e03067920ba6e167ad02b1fde0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6a2f727d5c5212142503a889f57ad43376ac07e03067920ba6e167ad02b1fde0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6a2f727d5c5212142503a889f57ad43376ac07e03067920ba6e167ad02b1fde0"
    sha256 cellar: :any_skip_relocation, sonoma:        "41845451202e5ff24dff0d7b82525a3651bda5d771366dd8bda213e9f03d48f8"
    sha256 cellar: :any_skip_relocation, ventura:       "41845451202e5ff24dff0d7b82525a3651bda5d771366dd8bda213e9f03d48f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "398de003a0e9e03751f0de8224dd6135344f5b0d58d735cc6c74b2e1972a5551"
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
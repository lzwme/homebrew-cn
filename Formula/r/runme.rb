class Runme < Formula
  desc "Execute commands inside your runbooks, docs, and READMEs"
  homepage "https:runme.dev"
  url "https:github.comrunmedevrunmearchiverefstagsv3.12.8.tar.gz"
  sha256 "9f5bf889dcbbe05d113e005cf91fcc2f6a716c44136737ed1edfec5484f1b31f"
  license "Apache-2.0"
  head "https:github.comrunmedevrunme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7a72ef0a56d3392f2f90e0483430edb1a9d7eb04d1fa4dd470a53f6ce4472f69"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7a72ef0a56d3392f2f90e0483430edb1a9d7eb04d1fa4dd470a53f6ce4472f69"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7a72ef0a56d3392f2f90e0483430edb1a9d7eb04d1fa4dd470a53f6ce4472f69"
    sha256 cellar: :any_skip_relocation, sonoma:        "f979eaa87aafe34bf823f0a604d53337326c81464ca80ffc63023b94768d3e7d"
    sha256 cellar: :any_skip_relocation, ventura:       "f979eaa87aafe34bf823f0a604d53337326c81464ca80ffc63023b94768d3e7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "24bec3f86eee8297fdb4b2f2817f03f2547d244df253dd544f629108d69d77c3"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comrunmedevrunmev3internalversion.BuildDate=#{time.iso8601}
      -X github.comrunmedevrunmev3internalversion.BuildVersion=#{version}
      -X github.comrunmedevrunmev3internalversion.Commit=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable(bin"runme", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}runme --version")
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
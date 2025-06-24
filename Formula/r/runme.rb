class Runme < Formula
  desc "Execute commands inside your runbooks, docs, and READMEs"
  homepage "https:runme.dev"
  url "https:github.comrunmedevrunmearchiverefstagsv3.14.1.tar.gz"
  sha256 "2a3c9a6a1370bc973364d43e2206e80e3c3e5602f3a704b5d401891226154d54"
  license "Apache-2.0"
  head "https:github.comrunmedevrunme.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c5a0d542668b2c118cb4de07bb19f89a7e38f9a2537fc800ed6994ec050d04c7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c5a0d542668b2c118cb4de07bb19f89a7e38f9a2537fc800ed6994ec050d04c7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c5a0d542668b2c118cb4de07bb19f89a7e38f9a2537fc800ed6994ec050d04c7"
    sha256 cellar: :any_skip_relocation, sonoma:        "59d2373552223c4140dbd12858fd1923a444af0baee01dba24a9ade35956a2c6"
    sha256 cellar: :any_skip_relocation, ventura:       "59d2373552223c4140dbd12858fd1923a444af0baee01dba24a9ade35956a2c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9ae874f606452464ab4c482218901a231024c73d2c31dc73696d28bef8bbdc24"
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
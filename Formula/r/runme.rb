class Runme < Formula
  desc "Execute commands inside your runbooks, docs, and READMEs"
  homepage "https:runme.dev"
  url "https:github.comrunmedevrunmearchiverefstagsv3.13.0.tar.gz"
  sha256 "488f6ed88d8adecda662ec7bb1557565d9cc1ce0c7a9394edc1554b360995d4e"
  license "Apache-2.0"
  head "https:github.comrunmedevrunme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5837c272c354f5a93876ef0affe42b507327d19447ce049abfc4f65073d8d07e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5837c272c354f5a93876ef0affe42b507327d19447ce049abfc4f65073d8d07e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5837c272c354f5a93876ef0affe42b507327d19447ce049abfc4f65073d8d07e"
    sha256 cellar: :any_skip_relocation, sonoma:        "928e1de098998aa152bbaba853dee272ce1010850c407670c8b0030f26a0fd76"
    sha256 cellar: :any_skip_relocation, ventura:       "928e1de098998aa152bbaba853dee272ce1010850c407670c8b0030f26a0fd76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b8d7b982de53fe25a7228b99385bb2e7832b1f817ad215d10f66905a2febd13"
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
class Runme < Formula
  desc "Execute commands inside your runbooks, docs, and READMEs"
  homepage "https:runme.dev"
  url "https:github.comrunmedevrunmearchiverefstagsv3.12.7.tar.gz"
  sha256 "26fa831b2848d75de42f9f48cfbe3c15ee6624336dc747cd3c52763bb76d3f35"
  license "Apache-2.0"
  head "https:github.comrunmedevrunme.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "87b33b519cd52117f0d32ce19bb0cbc6cd978df4c0c641ba08b56afa504772db"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "87b33b519cd52117f0d32ce19bb0cbc6cd978df4c0c641ba08b56afa504772db"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "87b33b519cd52117f0d32ce19bb0cbc6cd978df4c0c641ba08b56afa504772db"
    sha256 cellar: :any_skip_relocation, sonoma:        "cedba62de9f9bf7570ea77c27a12d626f1dcaef689fbe96929efbdc3a2a5c3da"
    sha256 cellar: :any_skip_relocation, ventura:       "cedba62de9f9bf7570ea77c27a12d626f1dcaef689fbe96929efbdc3a2a5c3da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0859c8177de3d4c97ec11e87ac0be649dbf74cd64c8079c1b70c8555e7c9b610"
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
class Runme < Formula
  desc "Execute commands inside your runbooks, docs, and READMEs"
  homepage "https://runme.dev/"
  url "https://ghfast.top/https://github.com/runmedev/runme/archive/refs/tags/v3.17.3.tar.gz"
  sha256 "0245ae3f7bd1e664ffca5bfa6ade566feb62052cd232d118e22c2eeb0ba5d36a"
  license "Apache-2.0"
  head "https://github.com/runmedev/runme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7f2e9473b5ea0336edc53c47f0adac7ef39f5728479558628ecd4ab49d55c07a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2ff0701701327d664d05939a397e8edd3a0e5616c820dc344371d0231e2e2783"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eef751aae43c7f77c20ebf60b29b2879e3aaebdafdab5d6af3c0d2050f159a11"
    sha256 cellar: :any_skip_relocation, sonoma:        "ccf5c2af991f087d8027d2f0aad4e3461693d5e2675c88dc7726c812efb1073f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8aeabdea6aba4fec0841b628026d3d6d545724fa3cb7bb542e4ca8fc91400eaf"
    sha256 cellar: :any,                 x86_64_linux:  "8f401391e6d31275f04cb41b1dfd608c7de3e348ebbfce9d4c8941c263270de7"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X github.com/runmedev/runme/v3/internal/version.BuildDate=#{time.iso8601}
      -X github.com/runmedev/runme/v3/internal/version.BuildVersion=#{version}
      -X github.com/runmedev/runme/v3/internal/version.Commit=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable(bin/"runme", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/runme --version")
    markdown = (testpath/"README.md")
    markdown.write <<~MARKDOWN
      # Some Markdown

      Has some text.

      ```sh { name=foobar }
      echo "Hello World"
      ```
    MARKDOWN
    assert_match "Hello World", shell_output("#{bin}/runme run --git-ignore=false foobar")
    assert_match "foobar", shell_output("#{bin}/runme list --git-ignore=false")
  end
end
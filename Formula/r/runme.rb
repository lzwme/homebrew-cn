class Runme < Formula
  desc "Execute commands inside your runbooks, docs, and READMEs"
  homepage "https://runme.dev/"
  url "https://ghfast.top/https://github.com/runmedev/runme/archive/refs/tags/v3.16.18.tar.gz"
  sha256 "c84f45e8a6acd13eebbb0432bcccdd37e5edaffe666a68ea05b0e114f239f0c8"
  license "Apache-2.0"
  head "https://github.com/runmedev/runme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1e42018d81db25a57dc0d5c41cbf313c03cb2f4349b3f74b1683076e656a1a34"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "de57e830b19f9b1a29554272e03e80e33fdb5ded6fb52614ba27db12276d47de"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "564f67c9cf8e33c368200ab6bcdd93213507ab2880cdf6b7097755ac91f5e925"
    sha256 cellar: :any_skip_relocation, sonoma:        "7d9add4627d622115eadb27ea616601cae98ffdc889c2fa96592e25dd651fbae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e2097b3efed5a5ef3a7281cb5a8c9f87049b4bf941b25477f7c49116d1b0ad96"
    sha256 cellar: :any,                 x86_64_linux:  "6e6cc4c9aba04c1912de83719bb596a64495f170f5712c1e2d18cfd783aca2ec"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
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
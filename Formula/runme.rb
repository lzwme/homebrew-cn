class Runme < Formula
  desc "Execute commands inside your runbooks, docs, and READMEs"
  homepage "https://runme.dev/"
  url "https://github.com/stateful/runme.git",
      tag:      "v1.5.0",
      revision: "b648529bc35b6ac10bb4c79c8f7149412c9bd101"
  license "Apache-2.0"
  head "https://github.com/stateful/runme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b46548e4e74169ddefb02e9f91fc9ed23fb16e2fe5210935de8d69e928656155"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a3633eb4dce8c6d2c002a409c70c9fcabd6721894a5cfd5d1abeebe5388d38f8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2990db321018d85f0dd24678f6479e2dcc47c5b9f74d75fae9cd361fa3fe5057"
    sha256 cellar: :any_skip_relocation, ventura:        "0feb1400557962f71eb49ac8adf518490c2b11d895b2f86a53391036e7c3bad5"
    sha256 cellar: :any_skip_relocation, monterey:       "8093af46fe86fffef2a7002b004092fe28e616e5ab3e5d4ea7de3b894ba20974"
    sha256 cellar: :any_skip_relocation, big_sur:        "e74b00fda428dd6750dda39abf6080150e002cd9d9b552dd8b82568ef11e0854"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "823b7959a2bf5fa7d8c9bae31bba8a65baf24abce0b397584e180427a7f2e225"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/stateful/runme/internal/version.BuildDate=#{time.iso8601}
      -X github.com/stateful/runme/internal/version.BuildVersion=#{version}
      -X github.com/stateful/runme/internal/version.Commit=#{Utils.git_head}
    ]

    system "go", "build", "-o", bin, *std_go_args(ldflags: ldflags), "./main.go"
    generate_completions_from_executable(bin/"runme", "completion", shells: [:bash, :zsh, :fish])
  end

  test do
    system "#{bin}/runme", "--version"
    markdown = (testpath/"README.md")
    markdown.write <<~EOS
      # Some Markdown

      Has some text.

      ```sh { name=foobar }
      echo "Hello World"
      ```
    EOS
    assert_match "Hello World", shell_output("#{bin}/runme run foobar")
    assert_match "foobar", shell_output("#{bin}/runme list")
  end
end
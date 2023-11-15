class Runme < Formula
  desc "Execute commands inside your runbooks, docs, and READMEs"
  homepage "https://runme.dev/"
  url "https://ghproxy.com/https://github.com/stateful/runme/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "bd29549e6b8b68c0cfb6002f4a89383ec4f7f84b1c68d3895169c65899cbb900"
  license "Apache-2.0"
  head "https://github.com/stateful/runme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7db6914969a2f15958053f8f0079cc55257083d92bb7f1ef3268a09c359ac20d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c86cd87621e82731c111330b263005d04a5a61c3b60a4d7bc2c32c872a48d66a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "42cc3b59a1aa6bbfe29dbef76c0a192b66ac97bf9c2f07628ddf3f9e118b2878"
    sha256 cellar: :any_skip_relocation, sonoma:         "71cab86d0579e13f000818c1ab7e536737389bab44c7a9f34b2cd7e159e89bb1"
    sha256 cellar: :any_skip_relocation, ventura:        "1231993e9a45e178608a6c41e3045a661728781d7dcc232b312a54a448d03505"
    sha256 cellar: :any_skip_relocation, monterey:       "3697c6300e0767f60dbf48d8bec14d2f1a1f8cc71638237768caab5945c393da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "807200b239eb390ac0b8c448423e6911ba4c5d50c878532827c4ad05dcae41dc"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/stateful/runme/internal/version.BuildDate=#{time.iso8601}
      -X github.com/stateful/runme/internal/version.BuildVersion=#{version}
      -X github.com/stateful/runme/internal/version.Commit=#{tap.user}
    ]

    system "go", "build", "-o", bin, *std_go_args(ldflags: ldflags)
    generate_completions_from_executable(bin/"runme", "completion")
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
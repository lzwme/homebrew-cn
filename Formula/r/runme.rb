class Runme < Formula
  desc "Execute commands inside your runbooks, docs, and READMEs"
  homepage "https://runme.dev/"
  url "https://ghproxy.com/https://github.com/stateful/runme/archive/refs/tags/v2.0.4.tar.gz"
  sha256 "b15041b5815a280770ce155ab8cf859bfba7f0ddeb6923c3cf86f8959a57f718"
  license "Apache-2.0"
  head "https://github.com/stateful/runme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "097d73b8cb7ae641891627517b6de8a770b83cc6911acd53ab9261fe64da98d5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f1188c0df766f99ab72c48a8e3af52f0b1e0b4b707f7127f8d9fe8e78467bb14"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "16d540ec500c368460afce383d9d109bb3bbf6b7f5b1b2bd6c19b8ebc43dc139"
    sha256 cellar: :any_skip_relocation, sonoma:         "84dadb4e0129ccf5368021d7dd1026aa222165bc186780d014914933c542a651"
    sha256 cellar: :any_skip_relocation, ventura:        "338a9624b55e431122f101eea944355398984239fcf8ab40c7c984d350a45097"
    sha256 cellar: :any_skip_relocation, monterey:       "56719f2438601e0cf82b37c64b73a0847f4924aa0cb1da4794dd7d39ed8c84df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7aa91c1019bf4d2c9bdd372ff6ab05aef2139f32f0d0faa22abfc183ec483053"
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
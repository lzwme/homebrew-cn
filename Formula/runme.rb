class Runme < Formula
  desc "Execute commands inside your runbooks, docs, and READMEs"
  homepage "https://runme.dev/"
  url "https://github.com/stateful/runme.git",
      tag:      "v1.6.0",
      revision: "3cca8a6e7d34f401c1bdd99828a7fac5b1d8fac9"
  license "Apache-2.0"
  head "https://github.com/stateful/runme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c5e34625912cc60ce423727a7711c192094276a9eed59b4bdc6ab276898c64fc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8709005b1298b7eda2f4789d6cf68b4e6de35a8276b94e93b31045f9d09d3dcd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "172aafbce56573f3efc6c9076b3fe647b176e10a274eb7ddff9df9be906dbdaa"
    sha256 cellar: :any_skip_relocation, ventura:        "ca05fb5c3beb7e34693da31d41e54c45c0ea644949148e0fe4dd91dcb4b08fca"
    sha256 cellar: :any_skip_relocation, monterey:       "094c55c782956c519087ca6ab7dcec98a37bccf4ee93f4f20f8b86146e6fc32b"
    sha256 cellar: :any_skip_relocation, big_sur:        "fb03b090baf388748d725a0123792d0bad93c33aee1c1ace09567007295998d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e2048d1361388fc8ccd84ce076fd759934902d90f73ab354a321b95d1b0c7cbb"
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
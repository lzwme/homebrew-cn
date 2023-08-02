class Runme < Formula
  desc "Execute commands inside your runbooks, docs, and READMEs"
  homepage "https://runme.dev/"
  url "https://github.com/stateful/runme.git",
      tag:      "v1.7.0",
      revision: "796a0854acdfa0f5e346ca6c33e8d2ea35b8179b"
  license "Apache-2.0"
  head "https://github.com/stateful/runme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1f521d4dc3add19fd1a3d4f2a266f73d5e115e3e9dea010526520f8bfe00cd22"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "15d0e4cbc5ee6676a9d541b400f41dc5693386d003775193fde364cc2e7fcc20"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6e52428fe717c9ce3b10b8168419c22d8339b4bb58b75b96d54dd2db800c7d10"
    sha256 cellar: :any_skip_relocation, ventura:        "a5ab9c498f604f60484d30613f9dfbd49e726d8a6be5073d7866f119369770f6"
    sha256 cellar: :any_skip_relocation, monterey:       "21da1b8b5b1249e7c1cdad59d4c9bbf6b3d44aee05b136cff4e8ef72ccca65da"
    sha256 cellar: :any_skip_relocation, big_sur:        "43ee4481c76d2a34f598515f66bf75bb9fe3932b5a7ace99841034e8e20019fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7751e3db72ec26a4c028f3d3f2fe6092b002a940fbe35475637d5a4f939a34d4"
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
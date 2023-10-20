class Runme < Formula
  desc "Execute commands inside your runbooks, docs, and READMEs"
  homepage "https://runme.dev/"
  url "https://ghproxy.com/https://github.com/stateful/runme/archive/refs/tags/v1.7.8.tar.gz"
  sha256 "50910596fce4bb697e09ed83807ba251f09ab5acd64da845419886297f24a81b"
  license "Apache-2.0"
  head "https://github.com/stateful/runme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b0c8089e88537fa6029cf131d620a36408943025519be632f324dcb71405e593"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a0c2035511a30df56bba32c1edeb5d0935d91fed8b4c9d819d952020c9149e69"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e22d0fa304fcb018c25a287453fc5873a05e4a7b8861120d3d328b9f23c984ea"
    sha256 cellar: :any_skip_relocation, sonoma:         "c0def3eb103f84bebe5888ae339edf7bfd2ddd33a2a2bbfcef9a3b7fca2556f6"
    sha256 cellar: :any_skip_relocation, ventura:        "4cdcfed007fa0b039c5747b46cc95203a644e04f14827fd71be8b4663b67d7db"
    sha256 cellar: :any_skip_relocation, monterey:       "807fb389b71e0c79ec47302da735e69afc394245256b56a8ee163dde7c2c8e74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc7f92de0bb2cf98a45fd726f85fb4066fd5adf69a8152ce523bed2f3e71eb7c"
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
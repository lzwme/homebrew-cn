class Revive < Formula
  desc "Fast, configurable, extensible, flexible, and beautiful linter for Go"
  homepage "https://revive.run"
  url "https://github.com/mgechev/revive.git",
      tag:      "v1.3.0",
      revision: "5db07b5c971648c8c59d0c84d176e94f11dfbcec"
  license "MIT"
  head "https://github.com/mgechev/revive.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2746bfb00e7613a3c82d18b6fc10f7bb9e49175c7289b4727a19187da3a1bda0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2746bfb00e7613a3c82d18b6fc10f7bb9e49175c7289b4727a19187da3a1bda0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2746bfb00e7613a3c82d18b6fc10f7bb9e49175c7289b4727a19187da3a1bda0"
    sha256 cellar: :any_skip_relocation, ventura:        "0a4a2d987c7b25a8e4b128d38e2315f82dfb66f29d85fbd3af9765f32234a213"
    sha256 cellar: :any_skip_relocation, monterey:       "0a4a2d987c7b25a8e4b128d38e2315f82dfb66f29d85fbd3af9765f32234a213"
    sha256 cellar: :any_skip_relocation, big_sur:        "0a4a2d987c7b25a8e4b128d38e2315f82dfb66f29d85fbd3af9765f32234a213"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "35c0e05a51fd357a44a80bfbd0aac78c82a78feb2653d30c002f353dbf91e091"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X main.commit=#{Utils.git_head}
      -X main.date=#{time.iso8601}
      -X main.builtBy=#{tap.user}
    ]
    ldflags << "-X main.version=#{version}" unless build.head?
    system "go", "build", *std_go_args(ldflags: ldflags.join(" "))
  end

  test do
    (testpath/"main.go").write <<~EOS
      package main

      import "fmt"

      func main() {
        my_string := "Hello from Homebrew"
        fmt.Println(my_string)
      }
    EOS
    output = shell_output("#{bin}/revive main.go")
    assert_match "don't use underscores in Go names", output
  end
end
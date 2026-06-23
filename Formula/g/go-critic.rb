class GoCritic < Formula
  desc "Opinionated Go source code linter"
  homepage "https://go-critic.com"
  url "https://ghfast.top/https://github.com/go-critic/go-critic/archive/refs/tags/v0.14.3.tar.gz"
  sha256 "baf54665063087dc48d2261822229a3d8ab670fcec38fc5e25cd6350732746cb"
  license "MIT"
  head "https://github.com/go-critic/go-critic.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c8ac5976a9105aca2ee7a6c2de13b87f7b7ac3503e7a412134ed1a4b6be29dfd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c8ac5976a9105aca2ee7a6c2de13b87f7b7ac3503e7a412134ed1a4b6be29dfd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c8ac5976a9105aca2ee7a6c2de13b87f7b7ac3503e7a412134ed1a4b6be29dfd"
    sha256 cellar: :any_skip_relocation, sonoma:        "64b54f005973ee0c63292a78bc708d6945cc59796acad2b4cb3d15a0a73c2a46"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8725ccacee3e88cffb3c2e3973910dfe0fe751499b12a48a45a74292c72843fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "591ca0248b7c16f1694750a06b359f45afeb70af8d293f7ff8fdb8551b8308aa"
  end

  depends_on "go"

  def install
    ldflags = "-s -w"
    ldflags += " -X main.Version=v#{version}" if build.stable?
    system "go", "build", *std_go_args(ldflags:), "./cmd/go-critic"
    bin.install_symlink bin/"go-critic" => "gocritic"
  end

  test do
    assert_predicate bin/"gocritic", :symlink?
    assert_equal "go-critic", (bin/"gocritic").readlink.to_s

    (testpath/"main.go").write <<~GO
      package main

      import "fmt"

      func main() {
        str := "Homebrew"
        if len(str) <= 0 {
          fmt.Println("If you're reading this, something is wrong.")
        }
      }
    GO

    output_go_critic = shell_output("#{bin}/go-critic check main.go 2>&1", 1)
    assert_match "sloppyLen: len(str) <= 0 can be len(str) == 0", output_go_critic

    output_gocritic = shell_output("#{bin}/gocritic check main.go 2>&1", 1)
    assert_match "sloppyLen: len(str) <= 0 can be len(str) == 0", output_gocritic
  end
end
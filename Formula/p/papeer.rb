class Papeer < Formula
  desc "Convert websites into eBooks and Markdown"
  homepage "https://papeer.tech"
  url "https://ghfast.top/https://github.com/lapwat/papeer/archive/refs/tags/v0.8.7.tar.gz"
  sha256 "8055548c34cfe21a993e41339a94f2fcb3c88cb27aeeaa2d3df3e6f63d2b1aff"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "99d419220084284a4d1652e9e779571f1493211c426b54d9eef56e7380066f1f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "99d419220084284a4d1652e9e779571f1493211c426b54d9eef56e7380066f1f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "99d419220084284a4d1652e9e779571f1493211c426b54d9eef56e7380066f1f"
    sha256 cellar: :any_skip_relocation, sonoma:        "2b926d672c39a815eaa4ebbc2d13764595941b1f58a5076e028889c04d739b1c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "34fb742d867b459e786bddff35561058d2ea488c57930f002dd2d69038f5cb96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "13c944fcd0ab6515d9af77dfa549b8494114a8a577bf7e38ea72461a225f5f45"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"papeer", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/papeer version")

    output = shell_output("#{bin}/papeer list https://12factor.net/ --selector='section.concrete>article>h2>a'")
    assert_match "8  VIII. Concurrency", output
  end
end
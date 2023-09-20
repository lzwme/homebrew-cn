class Fx < Formula
  desc "Terminal JSON viewer"
  homepage "https://fx.wtf"
  url "https://ghproxy.com/https://github.com/antonmedv/fx/archive/refs/tags/30.0.3.tar.gz"
  sha256 "a5d0e808c7b9ed3ccc2a4064ed01c28a3c5f94d66a0fb4469ebcc997426fc361"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "499af1e42ce91a997739c02d6df7d7ad016acbf60d083aa365ed9ec3c2549866"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "499af1e42ce91a997739c02d6df7d7ad016acbf60d083aa365ed9ec3c2549866"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "499af1e42ce91a997739c02d6df7d7ad016acbf60d083aa365ed9ec3c2549866"
    sha256 cellar: :any_skip_relocation, ventura:        "f9e7bc1c571f68e320bb64a74338539638ebe6840dedc2b6c99c2f248308e044"
    sha256 cellar: :any_skip_relocation, monterey:       "f9e7bc1c571f68e320bb64a74338539638ebe6840dedc2b6c99c2f248308e044"
    sha256 cellar: :any_skip_relocation, big_sur:        "f9e7bc1c571f68e320bb64a74338539638ebe6840dedc2b6c99c2f248308e044"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "718380fef8f9c17d7e0ef0fdca42f382e082e289b09397baaa51def46c28339b"
  end

  depends_on "go" => :build
  depends_on "node"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_equal "42", pipe_output("#{bin}/fx .", 42).strip
  end
end
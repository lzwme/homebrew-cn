class Gitsign < Formula
  desc "Keyless Git signing using Sigstore"
  homepage "https://github.com/sigstore/gitsign"
  url "https://ghproxy.com/https://github.com/sigstore/gitsign/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "3087506ef7811f2d26b6eb8612d4d0a4d8d8eec6258bca4f25247bb7a49e297c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fa9225d85fe2a0e99a27cb05b8aa48b253501aa07d4665a3ef582862153abe2a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cf31cd385128eb932cfb9bc2190b1e149c12c4a5f2b0c89b721332dad6091577"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "31f9e221c470d2de535055f17033f17d4e28e674808bce5cf260d4735a915cae"
    sha256 cellar: :any_skip_relocation, sonoma:         "e7d2b9c99d3c52f2783cd7dc9cc052277dad249e37b0e74f758dd92ea3744887"
    sha256 cellar: :any_skip_relocation, ventura:        "82a47bf4024643db45f5e46bd71b42e8a77a9d7f628ef935a9b9c0ae95a96cc3"
    sha256 cellar: :any_skip_relocation, monterey:       "0fcd4dfa7db1ba9db84627f6f7db102267ab58b9975227e9c68937e4f20c9b1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa69c3114229ddfb240001df72a44cbdabcfc190be15002bde33555429f78bd4"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/sigstore/gitsign/pkg/version.gitVersion=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"gitsign", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gitsign --version")

    system "git", "clone", "https://github.com/sigstore/gitsign.git"
    cd testpath/"gitsign" do
      require "pty"
      stdout, _stdin, _pid = PTY.spawn("#{bin}/gitsign attest")
      assert_match "Generating ephemeral keys...", stdout.readline
    end
  end
end
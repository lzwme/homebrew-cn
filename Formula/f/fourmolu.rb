class Fourmolu < Formula
  desc "Formatter for Haskell source code"
  homepage "https://github.com/fourmolu/fourmolu"
  url "https://ghproxy.com/https://github.com/fourmolu/fourmolu/archive/refs/tags/v0.14.1.0.tar.gz"
  sha256 "4ccf6bb2a2a9179ed30e94d14bb97b745ff897c4d62adefb3623a73d0f859567"
  license "BSD-3-Clause"
  head "https://github.com/fourmolu/fourmolu.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "79b5ff3487c49bb4038351320fa9ab06bbf2bbc0ddd1bd6aac0f0e11f60c8ce4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7555019a9d3f27bf2438ce1a27355615b4560e235eb2383e10b3726747e61249"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f1aa4aa331072371c02c3c156a4184c59b3ec4c0cc1fc1749688a9277bba2ea0"
    sha256 cellar: :any_skip_relocation, sonoma:         "011f472c722f147d1e6fd4498f354d5f06fc92d9beff5dd97772b7b9dc5f881f"
    sha256 cellar: :any_skip_relocation, ventura:        "1ac79a140c4bb3f8d067ae9b3b8c76c7ae6d56bbcaff9276424e3bb21f9ab06b"
    sha256 cellar: :any_skip_relocation, monterey:       "46a138346c5daa036595eca8aefbf89fd680d0c4a4eaf6e9a9e8eaf3475c9f74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c39e8ffcd56f474d9fc97e05a282661cf674a8bebbcc4481727eb961f2a439c"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    (testpath/"test.hs").write <<~EOS
      foo =
        f1
        p1
        p2 p3

      foo' =
        f2 p1
        p2
        p3

      foo'' =
        f3 p1 p2
        p3
    EOS
    expected = <<~EOS
      foo =
          f1
              p1
              p2
              p3

      foo' =
          f2
              p1
              p2
              p3

      foo'' =
          f3
              p1
              p2
              p3
    EOS
    assert_equal expected, shell_output("#{bin}/fourmolu test.hs")
  end
end
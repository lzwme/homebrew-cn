class Cgrep < Formula
  desc "Context-aware grep for source code"
  homepage "https://github.com/awgn/cgrep"
  url "https://ghproxy.com/https://github.com/awgn/cgrep/archive/v8.0.0.tar.gz"
  sha256 "8ea248f3b115bc1b4e24bb8b38401ddf0d670797749f8b7a149c07c0c39ad9fc"
  license "GPL-2.0-or-later"
  head "https://github.com/awgn/cgrep.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f12f0e079913987d7990256551766bc3d083445edf8b1bfdf926e5ec08f07349"
    sha256 cellar: :any,                 arm64_monterey: "e13372f7c3253b24ae5208826c048eb060c39c898950a11d841c331ef7548e43"
    sha256 cellar: :any,                 arm64_big_sur:  "73d5f916288c7143572691fa0803048840ce015d1f5c6095f0254d9928fd719a"
    sha256 cellar: :any,                 ventura:        "5bf643588cf02ee21dd4ef2ac4b8e6a17d1bc101129057a6710cd875dbb2fd48"
    sha256 cellar: :any,                 monterey:       "6ffd042cceb62c5d3e388a294770ef31a3d0a4dbac949f4489e298aafe703ea3"
    sha256 cellar: :any,                 big_sur:        "d7e75322c03cbfadb3d30a648c29a01f7128f3343cc0c94fee7d0df92f050d91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b330c5b3a52be9ed1ae9289b43b05a2197c56c0e49cad9856b9ff7c26272fdb"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "pkg-config" => :build
  depends_on "pcre"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    (testpath/"t.rb").write <<~EOS
      # puts test comment.
      puts "test literal."
    EOS

    assert_match ":1", shell_output("#{bin}/cgrep --count --comment test t.rb")
    assert_match ":1", shell_output("#{bin}/cgrep --count --literal test t.rb")
    assert_match ":1", shell_output("#{bin}/cgrep --count --code puts t.rb")
    assert_match ":2", shell_output("#{bin}/cgrep --count puts t.rb")
  end
end
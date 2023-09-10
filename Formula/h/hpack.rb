class Hpack < Formula
  desc "Modern format for Haskell packages"
  homepage "https://github.com/sol/hpack"
  url "https://ghproxy.com/https://github.com/sol/hpack/archive/0.35.5.tar.gz"
  sha256 "48dd4d3b66fb0631287c2afaf8261b471f98a2376ee6f0252832cdd7cac85cfa"
  license "MIT"
  head "https://github.com/sol/hpack.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "547854b9c5c141dee7c94af977222d646e115239fe8f2a93b5bc88b25c2bb98d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5cac8bd71e1ba98fcbfe15240bc587a5c5dd74b443c0931d62a946df963ac031"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9f621addbe7e80dfac23cef29795c15024db0040e4adcf789fa424fd54d97c15"
    sha256 cellar: :any_skip_relocation, ventura:        "f0c64f6eae95a2136e31964c83f56494e1405807620dd55fada7a3ba0a200b55"
    sha256 cellar: :any_skip_relocation, monterey:       "e55197613bc884ab254648715ccdc61a8547dcbfef06048f424e9d0f25df0231"
    sha256 cellar: :any_skip_relocation, big_sur:        "739ef17b5a8037765f8fe4c32ea23e0e52442f6304207f5e56a4fca1bdadd193"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "53911a87894c0d41c4748d547fac8e2abca67ec30925ea3e7a62bb8a92229103"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  uses_from_macos "zlib"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  # Testing hpack is complicated by the fact that it is not guaranteed
  # to produce the exact same output for every version.  Hopefully
  # keeping this test maintained will not require too much churn, but
  # be aware that failures here can probably be fixed by tweaking the
  # expected output a bit.
  test do
    (testpath/"package.yaml").write <<~EOS
      name: homebrew
      dependencies: base
      library:
        exposed-modules: Homebrew
    EOS
    expected = <<~EOS
      name:           homebrew
      version:        0.0.0
      build-type:     Simple

      library
        exposed-modules:
            Homebrew
        other-modules:
            Paths_homebrew
        build-depends:
            base
        default-language: Haskell2010
    EOS

    system "#{bin}/hpack"

    # Skip the first lines because they contain the hpack version number.
    assert_equal expected, (testpath/"homebrew.cabal").read.lines[6..].join
  end
end
class HaskellLanguageServer < Formula
  desc "Integration point for ghcide and haskell-ide-engine. One IDE to rule them all"
  homepage "https://github.com/haskell/haskell-language-server"
  url "https://ghproxy.com/https://github.com/haskell/haskell-language-server/archive/refs/tags/2.4.0.0.tar.gz"
  sha256 "67bbfae1275aabbfdb26869bc6df91feb58e03427cb76df89f74b864dbb5d57b"
  license "Apache-2.0"
  revision 1
  head "https://github.com/haskell/haskell-language-server.git", branch: "master"

  # we need :github_latest here because otherwise
  # livecheck picks up spurious non-release tags
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4ca1626c2e2efcefafaab806a625a14ae57fb6a64cb9f43090bf2d1ceea3959f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b7918d6e2f1fa5b58d60e28516eac5028f0334b66ab1e75b932300c0b5f879bc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a7c1e10939cadb8d6b160bdb1c2eb187637a191e4969310378db74ffb70c5202"
    sha256 cellar: :any_skip_relocation, sonoma:         "26aa2d10780198d9bcaa520c0c492bc6ef4cfb9ccb442b006a86805b93859d3c"
    sha256 cellar: :any_skip_relocation, ventura:        "ac96303407de0dc69874b565a11aec964aae5d1ad3817556d8df89b94d4d2fe9"
    sha256 cellar: :any_skip_relocation, monterey:       "052ac78f31285479a438210e2677572546875713150a1b17a203b24acd45faae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c08d30dfabd84fd385c4f7f77f13555ac491efd8ae51295761d8c67cd7ee448b"
  end

  depends_on "cabal-install" => [:build, :test]
  # ghc 9.8 support issue, https://github.com/haskell/haskell-language-server/issues/3861
  depends_on "ghc@9.2" => [:build, :test]
  depends_on "ghc@9.4" => [:build, :test]
  depends_on "ghc@9.6" => [:build, :test]

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def ghcs
    deps.map(&:to_formula)
        .select { |f| f.name.match? "ghc" }
        .sort_by(&:version)
  end

  def install
    system "cabal", "v2-update"

    ghcs.each do |ghc|
      system "cabal", "v2-install", "--with-compiler=#{ghc.bin}/ghc", "--flags=-dynamic", *std_cabal_v2_args

      hls = "haskell-language-server"
      bin.install bin/hls => "#{hls}-#{ghc.version}"
      bin.install_symlink "#{hls}-#{ghc.version}" => "#{hls}-#{ghc.version.major_minor}"
      (bin/"#{hls}-wrapper").unlink if ghc != ghcs.last
    end
  end

  def caveats
    ghc_versions = ghcs.map(&:version).map(&:to_s).join(", ")

    <<~EOS
      #{name} is built for GHC versions #{ghc_versions}.
      You need to provide your own GHC or install one with
        brew install #{ghcs.last}
    EOS
  end

  test do
    valid_hs = testpath/"valid.hs"
    valid_hs.write <<~EOS
      f :: Int -> Int
      f x = x + 1
    EOS

    invalid_hs = testpath/"invalid.hs"
    invalid_hs.write <<~EOS
      f :: Int -> Int
    EOS

    ghcs.each do |ghc|
      with_env(PATH: "#{ghc.bin}:#{ENV["PATH"]}") do
        assert_match "Completed (1 file worked, 1 file failed)",
          shell_output("#{bin}/haskell-language-server-#{ghc.version.major_minor} #{testpath}/*.hs 2>&1", 1)
      end
    end
  end
end
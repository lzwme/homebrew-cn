class Patat < Formula
  desc "Terminal-based presentations using Pandoc"
  homepage "https:github.comjaspervdjpatat"
  url "https:hackage.haskell.orgpackagepatat-0.14.2.0patat-0.14.2.0.tar.gz"
  sha256 "ee9d06575907495192569b1bea4c98c74f811f925276e214eb86bb6e0ee20e6a"
  license "GPL-2.0-or-later"
  head "https:github.comjaspervdjpatat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "68799b0e08262bee8fea0c677d4f3037a4a8825b82d734a572d94f4f2b56836a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "106cfd8d5ab833419847bf20612b149d75e1dde200896620e0210f8728618f8f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b9f6f7d3493853c09c02fd0adcc7b63f7ccffcb0d678a38fef839a23599351ca"
    sha256 cellar: :any_skip_relocation, sonoma:        "036fbcb7da38ef5153076c22637e66ed7e2e827772abf336ba32a87575061dcb"
    sha256 cellar: :any_skip_relocation, ventura:       "751fb0046d8b57af77917d339e3fc0348f8356cfe10dd0b61cba05d3165f35dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d3eb3d8086ec918d4c3498e43b0f1792a8363c0a26804a8c697a77bf2318a5a"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9.10" => :build
  depends_on "pandoc" => :build
  depends_on "pkgconf" => :build

  uses_from_macos "zlib"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    test_file = testpath"test.md"
    test_file.write <<~MARKDOWN
      # Hello from Patat
      Slide 1
      ---
      Slide 2
    MARKDOWN
    output = shell_output("#{bin}patat --dump --force #{test_file}")
    assert_match "Hello from Patat", output

    assert_match version.to_s, shell_output("#{bin}patat --version")
  end
end
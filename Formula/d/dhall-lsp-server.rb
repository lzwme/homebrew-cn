class DhallLspServer < Formula
  desc "Language Server Protocol (LSP) server for Dhall"
  homepage "https:github.comdhall-langdhall-haskelltreemasterdhall-lsp-server"
  license "BSD-3-Clause"
  head "https:github.comdhall-langdhall-haskell.git", branch: "main"

  stable do
    url "https:hackage.haskell.orgpackagedhall-lsp-server-1.1.3dhall-lsp-server-1.1.3.tar.gz"
    sha256 "885595eb731bd2eab28073751b9981e0406e69c4a8288748675439d0b0968ded"

    # Backport relaxed upper bound on lens. Remove on next release.
    patch :p2 do
      url "https:github.comdhall-langdhall-haskellcommit5e817a9c6bccf72123a3c67961af149b32d75c10.patch?full_index=1"
      sha256 "f66004893312b9001e2dd122880c63d0e6fccbc7af0e8a549a08a171d99e2d07"
    end

    # Backport https:github.comdhall-langdhall-haskellcommitd7a024e1ff87b89a64e51699e3f609fd4a719451
    patch do
      url "https:raw.githubusercontent.comHomebrewformula-patches039ff700fbd7682314f2ceb0dd0fcb0040e30c46dhall-lsp-serverghc-9.6.patch"
      sha256 "aff01a4c9fda024a3cf51067a8762cf74ee8b9cc3f8cd63812e9410f6044ed96"
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "be84073f0eab1bca53d11e14033e15d1ba9b98a71bb6f1109d257fed2df6f32f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3aa48be14dd82f80c0b18dbf2749425279a382c68994febf412085f4b219835c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "404e71e6c61f8838993cdf6640c0b567002ed11a9c9d3c05d375370eeb71eb24"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "65e8c3a933db681ef99efadb8fe8e8461ace1816a5f32f2b038f990d9f0435c5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cccd4dcfde8ad35f651d8d782670238ba3adeaa78e62a686a855adacea98c53f"
    sha256 cellar: :any_skip_relocation, sonoma:         "491813c677ada773203f55c47688adc27dab63a90685bfae30cdf61ccbe06585"
    sha256 cellar: :any_skip_relocation, ventura:        "9dc9ecacf5601cce00502a0f2e19ba14c2d941e231a90607cdf76cf889b86d57"
    sha256 cellar: :any_skip_relocation, monterey:       "d5a3138a0c6445e855ece84b1e5a9171d94ace5d3752b57054eb1c4bbd19ba8b"
    sha256 cellar: :any_skip_relocation, big_sur:        "5a4548b37b445c1875bed0e54123157e73d5bab76bbb61dcf2ccbabeb22c2902"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "994efb7ca3ec4bb7af8d557d1a6393d699c3a0fd6b8ee8902478e2b1104f6aa1"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9.8" => :build

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    args = []
    if build.head?
      cd name
    else
      # Backport support for GHC 9.8
      odie "Try removing workaround!" if version > "1.1.3"
      args += ["--allow-newer=dhall-json:aeson"]
      inreplace "#{name}.cabal" do |s|
        # https:github.comdhall-langdhall-haskellcommit28d346f00d12fa134b4c315974f76cc5557f1330
        s.gsub! ", mtl                  >= 2.2.2    && < 2.3", ", mtl                  >= 2.2.2    && < 2.4"
        s.gsub! ", transformers         >= 0.5.5.0  && < 0.6", ", transformers         >= 0.5.5.0  && < 0.7"
        # https:github.comdhall-langdhall-haskellcommit587c0875f9539a526037712870c45cc8fe853689
        s.gsub! "  aeson                >= 1.3.1.1  && < 2.2", "  aeson                >= 1.3.1.1  && < 2.3"
      end
    end

    system "cabal", "v2-update"
    system "cabal", "v2-install", *args, *std_cabal_v2_args
  end

  test do
    input =
      "Content-Length: 152\r\n" \
      "\r\n" \
      "{\"jsonrpc\":\"2.0\",\"id\":1,\"method\":\"initialize\",\"params\":{\"" \
      "processId\":88075,\"rootUri\":null,\"capabilities\":{},\"trace\":\"ver" \
      "bose\",\"workspaceFolders\":null}}\r\n" \
      "Content-Length: 46\r\n" \
      "\r\n" \
      "{\"jsonrpc\":\"2.0\",\"id\":1,\"method\":\"shutdown\"}\r\n" \
      "Content-Length: 42\r\n" \
      "\r\n" \
      "{\"jsonrpc\":\"2.0\",\"id\":1,\"method\":\"exit\"}\r\n"

    output = pipe_output(bin"dhall-lsp-server", input, 0)

    assert_match(^Content-Length: \d+i, output)
    assert_match "dhall.server.lint", output
  end
end
class Elm < Formula
  desc "Functional programming language for building browser-based GUIs"
  homepage "https://elm-lang.org"
  url "https://ghproxy.com/https://github.com/elm/compiler/archive/refs/tags/0.19.1.tar.gz"
  sha256 "aa161caca775cef1bbb04bcdeb4471d3aabcf87b6d9d9d5b0d62d3052e8250b1"
  license "BSD-3-Clause"

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "931f251316bf041c3f380e6f5701ddb6445fd0c2f4ef395fee1fab041d8e7f30"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ff99c87ecd2cb25c5a86b1988ecdc8326c8257f02a93024c42a91ca3107eef43"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "85f72af4af1b44ea8bcd28947583173c7e857cbaa9f9bca31dd2544d8915bf54"
    sha256 cellar: :any_skip_relocation, sonoma:         "114104b3a08b3d609c9fdbe01f0216c2b5e689ac0f36ba7ec9855e01e6e5412c"
    sha256 cellar: :any_skip_relocation, ventura:        "57f7be542255990ab3f4f95c014ee98bd5943dd1c4af92cee1d1f994e55c513c"
    sha256 cellar: :any_skip_relocation, monterey:       "bbf5b72f0ce8a8a15eec445e56702d983a955da17b05828f69c5634bfcc5ee5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cbb29db68081d05284e41a32a2deb06c4696a3a6db0adea067754c44057d7af9"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  patch do
    # elm's tarball is not a proper cabal tarball, it contains multiple cabal files.
    # Add `cabal.project` lets cabal-install treat this tarball as cabal project correctly.
    # https://github.com/elm/compiler/pull/2159
    url "https://github.com/elm/compiler/commit/eb566e901a419a6620e43c18faf89f57f0827124.patch?full_index=1"
    sha256 "556ff15fb4d8e5ca6e853280e35389c8875fa31a543204b315b55ec2ac967624"
  end

  patch do
    # These patches allow elm to build on ghc 9.4+.
    url "https://github.com/elm/compiler/commit/0421dfbe48e53d880a401e201890eac0b3de5f06.patch?full_index=1"
    sha256 "b498e39112ab7306b18b47821e799bf436d0c2151836187388c2a6b6f32bd437"
  end

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    # create elm.json
    elm_json_path = testpath/"elm.json"
    elm_json_path.write <<~EOS
      {
        "type": "application",
        "source-directories": [
                  "."
        ],
        "elm-version": "0.19.1",
        "dependencies": {
                "direct": {
                    "elm/browser": "1.0.0",
                    "elm/core": "1.0.0",
                    "elm/html": "1.0.0"
                },
                "indirect": {
                    "elm/json": "1.0.0",
                    "elm/time": "1.0.0",
                    "elm/url": "1.0.0",
                    "elm/virtual-dom": "1.0.0"
                }
        },
        "test-dependencies": {
          "direct": {},
            "indirect": {}
        }
      }
    EOS

    src_path = testpath/"Hello.elm"
    src_path.write <<~EOS
      module Hello exposing (main)
      import Html exposing (text)
      main = text "Hello, world!"
    EOS

    out_path = testpath/"index.html"
    system bin/"elm", "make", src_path, "--output=#{out_path}"
    assert_predicate out_path, :exist?
  end
end
class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdx/rtx"
  url "https://ghproxy.com/https://github.com/jdx/rtx/archive/refs/tags/v2023.12.24.tar.gz"
  sha256 "7f5ca83cbddee992aaac340d26c7a5d9511d59d61a7eec923421b4c5ef1604fd"
  license "MIT"
  head "https://github.com/jdx/rtx.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ab349ec1dc5f909cb3f37ff8bfc694b6308ad601ff3b6f123d896cf1d86cdda7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1e1ff1e2928521c13211167c27941d357a52d4bdb3dec555c7d8701444cedef1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8525cc87837e60db02101b1a9e791d161a89064c1ca7e792dc2eeb88a8b43740"
    sha256 cellar: :any_skip_relocation, sonoma:         "f20fb89f115c07f9efd85f9436084b972cc7ddfbe9a0ee8585193158e62cd4a4"
    sha256 cellar: :any_skip_relocation, ventura:        "029e2a130285d7dd30dea16e91f3003207f11c71699390a9c5bca8fb74b6a0b4"
    sha256 cellar: :any_skip_relocation, monterey:       "b298f4a8bd6865a216d6afdb1f71e5f4c8427f399183c5c2b5cc8eb55e6e91ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1cbbf133ceca194555ed6423ae18a649a82cf4de7e9019649d7ae586983571c1"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "man/man1/rtx.1"
    generate_completions_from_executable(bin/"rtx", "completion")
    lib.mkpath
    touch lib/".disable-self-update"
    (share/"fish"/"vendor_conf.d"/"rtx-activate.fish").write <<~EOS
      if [ "$RTX_FISH_AUTO_ACTIVATE" != "0" ]
        #{bin}/rtx activate fish | source
      end
    EOS
  end

  test do
    system "#{bin}/rtx", "install", "nodejs@18.13.0"
    assert_match "v18.13.0", shell_output("#{bin}/rtx exec nodejs@18.13.0 -- node -v")
  end
end
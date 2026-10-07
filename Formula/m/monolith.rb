class Monolith < Formula
  desc "CLI tool for saving complete web pages as a single HTML file"
  homepage "https://github.com/Y2Z/monolith"
  url "https://ghfast.top/https://github.com/Y2Z/monolith/archive/refs/tags/v2.11.2.tar.gz"
  sha256 "0591c98455662deb9cad92d3abf0e26f9133d917a1cc2ea13651bee69f5c9779"
  license "CC0-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f98e14e94c29ca4089c67492299aeb79ee9273fd1922846e404b2c3285cc4a6c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0a4ca331319a15e97cfc220dd05a35572196235a36d989906d3db823654dc0f0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2126a6254e8cfea1b43017f243094a28cb98f17649ef5a55b07aa15a957f3a31"
    sha256 cellar: :any,                 arm64_linux:       "35b6c5ea095bf06bb35bd199f2b6d9b063a8457516073e5bf3443d769d074314"
    sha256 cellar: :any,                 x86_64_linux:      "006884beff1756f61f3e97358763ba3fada4d964f176f704262de421a1256a9c"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"monolith", "https://lyrics.github.io/db/P/Portishead/Dummy/Roads/"
  end
end
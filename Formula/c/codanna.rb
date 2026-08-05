class Codanna < Formula
  desc "Code intelligence system with semantic search"
  homepage "https://docs.codanna.sh/"
  url "https://ghfast.top/https://github.com/bartolli/codanna/archive/refs/tags/v0.13.2.tar.gz"
  sha256 "28a62e23bd043c263fd42641c6d92c0a2126d9956c1bc8b33a2669e12cad654b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "02641c75cb90a4a8db3332d9e81b062393d4be7a5c7adb6d94a80f56a72471a3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "78b9397943b4a5419fb152f68c5454f166d0e8779a6c6f798878483032525454"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "12f49ee2cc904b62c74291ca1eeb84433e566c27c87006810f059517dcbd975e"
    sha256 cellar: :any_skip_relocation, sonoma:        "3ece685c5248d28c7ebda8750afcc1b09833f3249e3e058f98336b519014759c"
    sha256 cellar: :any,                 arm64_linux:   "a952e627f0bc341c9b5a658eda9cc81e61703c12f820bd5e98822f484537848a"
    sha256 cellar: :any,                 x86_64_linux:  "6bc178fc504724e33e8d35ac811fa346a7a6056ea963503dba7d91ea8797a187"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args, "--all-features"
  end

  test do
    system bin/"codanna", "init"
    assert_path_exists testpath/".codanna"
  end
end
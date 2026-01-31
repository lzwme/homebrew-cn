class Codanna < Formula
  desc "Code intelligence system with semantic search"
  homepage "https://github.com/bartolli/codanna"
  url "https://ghfast.top/https://github.com/bartolli/codanna/archive/refs/tags/v0.9.14.tar.gz"
  sha256 "4ae16eafe3b90abdc71ad172f10b8777dafb0edb173c66ab5f81c89dd49506ea"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "20afcf58ad35206784291034bac752c03ce5c976ce9ba3725dce07fea14c3f1f"
    sha256 cellar: :any,                 arm64_sequoia: "516e7668d8b3ffb4b7e12a0696eb1676b15b74042c07e1bffa979cf09a142410"
    sha256 cellar: :any,                 arm64_sonoma:  "8f44927255ad1b570d1f916c86745b7ffbd6098cb2a9411626dde64424e41f25"
    sha256 cellar: :any,                 sonoma:        "bbee46b27be0d790398d3a445bca961286be79dc4cfcfa320b5e5ab8dc767d0f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "58dcef4d4e8e3a3f4a5bd4a8ff6866c314fc9eac2d2b019bbddd1ed6dfa30b52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aacb2f5721297606bbff87fec5e2b052dd253596b2f719b093e39927931e8563"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args, "--all-features"
  end

  test do
    system bin/"codanna", "init"
    assert_path_exists testpath/".codanna"
  end
end
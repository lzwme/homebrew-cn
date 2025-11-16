class Decasify < Formula
  desc "Utility for casting strings to title-case according to locale-aware style guides"
  homepage "https://github.com/alerque/decasify"
  url "https://ghfast.top/https://github.com/alerque/decasify/releases/download/v0.11.1/decasify-0.11.1.tar.zst"
  sha256 "f2b6bb59af7f7cab3d50063e1622dcf490f344b378e5c02de91cba3f7ff32fa5"
  license "LGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fce92ade4da5b160000dcf3892755ff0aa982e9c8074f202fd1b21f4bd9fa677"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d76407645857e26a0f1ee7fea21d61f19ce3450d3d712a364ae28ae51ce5eb4e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6b18a4ec687f74c85ffcc603ee12158731b3001fe456c56e6de37c91c2a4dc2f"
    sha256 cellar: :any_skip_relocation, sonoma:        "93937699d3d22da5a1db08301ce492dc26b4e240b44dd193e4a0bb78576e248b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9ac2b7dc325444a8551d270a0a5aff3a5ead8f3df3677b18c3ad18f5c235a5c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "129d5b7b0769da301dc50e55d222cbfb2dfd69bf2b419c7d132bbb6e21a3ed70"
  end

  head do
    url "https://github.com/alerque/decasify.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "jq" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "./bootstrap.sh" if build.head?
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    assert_match "decasify v#{version}", shell_output("#{bin}/decasify --version")
    assert_match "Ben ve İvan", shell_output("#{bin}/decasify -l tr -c title 'ben VE ivan'")
  end
end
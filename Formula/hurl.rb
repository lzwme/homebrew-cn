class Hurl < Formula
  desc "Run and Test HTTP Requests with plain text and curl"
  homepage "https://hurl.dev"
  url "https://ghproxy.com/https://github.com/Orange-OpenSource/hurl/archive/refs/tags/3.0.0.tar.gz"
  sha256 "7ad9a1043129edb4850727c085a83010b916b3515c2af5afddd0809c1e2bd85c"
  license "Apache-2.0"
  head "https://github.com/Orange-OpenSource/hurl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "72c9ebcdefeeff9d4efd3ebb25c53ae6902b414f3f0ae5ec5f03644dbc7821c9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "46471d466711b420b1743e84827806e97d78aff9af78d0134630b0c27793a4ee"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bec4b1154d2a0141a93c450cce141dc88928c066e53a172daf07ee2405928a36"
    sha256 cellar: :any_skip_relocation, ventura:        "1d398aca1c2bb1fe791eb266fc9ba5c184502439e25393e9dbe0271fa4a3f1df"
    sha256 cellar: :any_skip_relocation, monterey:       "35122c3acd208c6d250e6f1e19b7411c6dded41841cf318be5d4c58f5275da01"
    sha256 cellar: :any_skip_relocation, big_sur:        "6051d2698709f1e3a12f6f0f2fc299777966176303cbca266707b38c5ec3c0f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "273781afd4ff73f60578a575f9fdcd5e4123fe55a889e265d8ec7bd87a954c51"
  end

  depends_on "rust" => :build

  uses_from_macos "curl"
  uses_from_macos "libxml2"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@1.1"
  end

  def install
    ENV["OPENSSL_DIR"] = Formula["openssl@1.1"].opt_prefix if OS.linux?

    system "cargo", "install", *std_cargo_args(path: "packages/hurl")
    system "cargo", "install", *std_cargo_args(path: "packages/hurlfmt")

    man1.install "docs/manual/hurl.1"
    man1.install "docs/manual/hurlfmt.1"
  end

  test do
    # Perform a GET request to https://hurl.dev.
    # This requires a network connection, but so does Homebrew in general.
    filename = (testpath/"test.hurl")
    filename.write "GET https://hurl.dev"
    system "#{bin}/hurl", "--color", filename
    system "#{bin}/hurlfmt", "--color", filename
  end
end
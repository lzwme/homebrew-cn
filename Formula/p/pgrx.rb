class Pgrx < Formula
  desc "Build Postgres Extensions with Rust"
  homepage "https:github.compgcentralfoundationpgrx"
  url "https:github.compgcentralfoundationpgrxarchiverefstagsv0.13.0.tar.gz"
  sha256 "daa6e011de5e15b1a8445b98f31f3d6416de11cd36bdb5c351e3ab29968b3ef7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "885e886fefe593a730fc3420d89865378174af70f4e1e9cf62c3cff1f3c125bb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9c97cae30168b41d2545896d59658b1a7a159d43b5b98ff5a95a0c0246931ed7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ab0cfe190d0d3148d8874fec5836d42e5152766e2bd787e334b27b5819c900fc"
    sha256 cellar: :any_skip_relocation, sonoma:        "4449a9f1c3d891c061e84e4d250ab5766130ee285d8b90c747115df11e34d0c7"
    sha256 cellar: :any_skip_relocation, ventura:       "da27217b7c40c8b4e28ca145bdc879d4e8b37a2ff11564662be4d23a3f7956fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f3e8f6316113c5c0f5a8847ddc8d938306a98872e9f2d0a50b8bb5bc109eeb83"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "rustup" => :test
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args(path: "cargo-pgrx")
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https:github.comHomebrewhomebrew-corepull134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "default", "beta"
    system "rustup", "set", "profile", "minimal"

    system "cargo", "pgrx", "new", "my_extension"
    assert_path_exists testpath"my_extensionmy_extension.control"
  end
end
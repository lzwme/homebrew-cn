class Pgrx < Formula
  desc "Build Postgres Extensions with Rust"
  homepage "https:github.compgcentralfoundationpgrx"
  url "https:github.compgcentralfoundationpgrxarchiverefstagsv0.13.1.tar.gz"
  sha256 "4416fc78cf5758931d0fd220c8343d3a8255e98af81833e87234fe35f02df7a0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "229720422d7a56ee5780fe8dd87d086820b9151829153493f67fb8a85390f188"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bdf3c63cdef75b4570d7b43db86878446054ee6f5ac2888232c4749ca6a1db8a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "371bc19c907b50402cf6100f191c597c7130afdd539f206150e87c55799887d2"
    sha256 cellar: :any_skip_relocation, sonoma:        "01040beae0a8e57c3680c1368f1927a1b4c0a3a42b4734da79235d1a098ef17b"
    sha256 cellar: :any_skip_relocation, ventura:       "54b5e97dbcfc280f1d884d6de16fd660d5b2df7c93070033d41e66c46067b782"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1f9cad5d2f19aabb5fdccc23b76c05c90df5366d80a8c7f89c6544522f2c93da"
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
class Pgrx < Formula
  desc "Build Postgres Extensions with Rust"
  homepage "https://github.com/pgcentralfoundation/pgrx"
  url "https://ghfast.top/https://github.com/pgcentralfoundation/pgrx/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "f8f555332946a19bc029d086a9f6651e3be0a55e6634b62dbfa412e1fe8876a2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a7b77637f39c9aa1329cde84ebfd05ea9c94df45cfd19c7df2535761cf9b4d1f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eabb2b5b31cef2b7b4077d4c390cc4922e876997e638d564531c0ebb445c8264"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7ed575677efcd2eb8c42db82952081381c9c813141f3401ec8b95cb3a1e5bcd5"
    sha256 cellar: :any_skip_relocation, sonoma:        "64da2cd24e723d0590b558d1675158de4a1aadf1a1ba80bea49131b0f0909eca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6eb0fa6d74a1a1d6de725866eab5b486707afb64decc61cc3c07cf90db948f8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6922fc3f29f9bbb26ea896b8f2d56e0cb15cdce5747b54c6b1c90df602b91178"
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
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "set", "profile", "minimal"
    system "rustup", "default", "beta"

    system "cargo", "pgrx", "new", "my_extension"
    assert_path_exists testpath/"my_extension/my_extension.control"
  end
end
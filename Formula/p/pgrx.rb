class Pgrx < Formula
  desc "Build Postgres Extensions with Rust"
  homepage "https:github.compgcentralfoundationpgrx"
  url "https:github.compgcentralfoundationpgrxarchiverefstagsv0.14.2.tar.gz"
  sha256 "3d3d45d225756a7dadfaed3b22c3a0898b5292968314747c5f4de3c4a96f497d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "73f0c406bebd43959455aeff419442dd183f50a4334c6952d88cadfd3789e3fd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d6f04a4c9a14d67ab5ee51f14d4a09a346558c9a7392139bfba93a3d8aac5f48"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a1e78d65541f458e0e4772cf0ce22da31becfc4415d0f30fbf0b6b1dbf4426ce"
    sha256 cellar: :any_skip_relocation, sonoma:        "d4d597c9e49f2e68d67b1b3a1f59e1522ad852b89042a5bbbe2bd71e8698e597"
    sha256 cellar: :any_skip_relocation, ventura:       "3e098fc95719bdacdf15b368694ffa63a562c3fbe24f76695184befebb63d3d2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "69bd019df33da3eeb8a704c5c60db8246a56e1e1135d8d617fcd4537c0fabfe8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b077d3db94e29075d1a3a3e076f455139f9514160b9a1a1cdc733512c6fc4e68"
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
    system "rustup", "set", "profile", "minimal"
    system "rustup", "default", "beta"

    system "cargo", "pgrx", "new", "my_extension"
    assert_path_exists testpath"my_extensionmy_extension.control"
  end
end
class CargoHack < Formula
  desc "Cargo subcommand to provide options for testing and continuous integration"
  homepage "https://github.com/taiki-e/cargo-hack"
  url "https://ghfast.top/https://github.com/taiki-e/cargo-hack/archive/refs/tags/v0.6.40.tar.gz"
  sha256 "10e72b441d0b20244226ba7d02d8942b7fb6c58cb058018aeddfab071724633c"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/taiki-e/cargo-hack.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f25f505394e4f8c6e0c1921c9ce59d5b8728dbf695dfa13261ca7a9a0dfba18c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "151105cb2fea83e57265a04c064261d208c7a2903d86e9cf82ab83054626f766"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "55bc37a86b3cbd163fca4fbc9c556e50bc1eda0e7fb70b2ad41da0e25c4dc893"
    sha256 cellar: :any_skip_relocation, sonoma:        "a87530c9418c02411703bf9b870d054f69113d2f36970ef8f4f96b313bb5200a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3eef7f4aa09f3889222d84cf55f62648289c8d0c03942673b2966cd261bfed8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "13e3c1ad02da1fe92fb535198184f66f1bdffb04c283b1872d928f4461be670b"
  end

  depends_on "rust" => :build
  depends_on "rustup" => :test

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "set", "profile", "minimal"
    system "rustup", "default", "beta"

    system "cargo", "new", "hello_world"
    cd "hello_world" do
      assert_match "Finished `dev` profile [unoptimized + debuginfo]", shell_output("cargo hack check 2>&1")
    end
  end
end
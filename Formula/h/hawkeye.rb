class Hawkeye < Formula
  desc "Simple license header checker and formatter, in multiple distribution forms"
  homepage "https://github.com/korandoru/hawkeye"
  url "https://ghfast.top/https://github.com/korandoru/hawkeye/archive/refs/tags/v7.1.0.tar.gz"
  sha256 "f74f5997a4d18595320a0d7aa63333268c9015000e93bfbd1aef7e74ea5769d1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c6338f0724026d8690f50e7d84070e3224fd5b05be5a7886d67ef77c62b74cf6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "730de1514a15e65aea9cc343c9fe0e5a41e937df7ee286d2f637226afc08ab11"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "476d3e80b3ebb6a64186f6afea0e59ef07859e0a5aaf3a2e3cde965bed3d573a"
    sha256 cellar: :any,                 arm64_linux:   "a390f5d03cc18f0ca94960eb735c1650ee3f1060b93c3e950fae96c1d14d99c4"
    sha256 cellar: :any,                 x86_64_linux:  "050c7b84fc1f8ed5c74b0a9f858074d0058c054bb4937fcd513f9fcf84811cde"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "hawkeye")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hawkeye --version")

    configfile = testpath/"licenserc.toml"
    configfile.write <<~TOML
      includes = ["licenserc.toml"]
    TOML

    assert_match "unknown field `includes`", shell_output("#{bin}/hawkeye format 2>&1", 2)
  end
end
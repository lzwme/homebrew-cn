class Bkmr < Formula
  desc "Unified CLI Tool for Bookmark, Snippet, and Knowledge Management"
  homepage "https://github.com/sysid/bkmr"
  url "https://ghfast.top/https://github.com/sysid/bkmr/archive/refs/tags/v4.31.0.tar.gz"
  sha256 "1ee9c412371152a15ab51d4ad968d520a54e2afec162c8d81b856660b1989e64"
  license "BSD-3-Clause"
  head "https://github.com/sysid/bkmr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ee1158f0c085e95ad90f3bfc5bceabc3ddbbcc68e22fde4df1ddb2fa1b66c80b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9330fb25562a07c566e30bb425715ac162f0593ff0f02a461e024d2203e17fc5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b6432a98184018c5bd69a41e1bc92760848064596e26566c1c1bd6a5087899c0"
    sha256 cellar: :any_skip_relocation, sonoma:        "0eb0998580a4e2aaf9efd0f0d538cc08092b5e3e9e5fbd167713c48964774796"
    sha256 cellar: :any_skip_relocation, ventura:       "5a6a99c7eee452852b620589bf697fdff49c4829a2c6aeac5e5b8fae8c049773"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8efb81fad52c82730b10c4fc8193db67c1df5d53d9efe80738242bec79bbddb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "59d1ca466ab94f488ec3497ecb0248f9f33e1a3b2df39efcd094576c77fafcf5"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "python"

  def install
    cd "bkmr" do
      # Ensure that the `openssl` crate picks up the intended library.
      # https://docs.rs/openssl/latest/openssl/#manual
      ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix

      system "cargo", "install", *std_cargo_args
    end

    generate_completions_from_executable(bin/"bkmr", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bkmr --version")

    output = shell_output("#{bin}/bkmr info")
    assert_match "Database URL: #{testpath}/.config/bkmr/bkmr.db", output
    assert_match "Database Statistics", output
  end
end
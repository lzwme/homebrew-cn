class Yozefu < Formula
  desc "TUI for exploring data in a Kafka cluster"
  homepage "https:github.comMAIFyozefu"
  url "https:github.comMAIFyozefuarchiverefstagsv0.0.8.tar.gz"
  sha256 "07c134b2085e60762120e56b9d168fb699e63bf53727b1eb8047a97f1d86e203"
  license "Apache-2.0"
  head "https:github.comMAIFyozefu.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ac81c5463056773a0788e30f5a4bdbc49344f09eea3ba7588c469b6a02dad23e"
    sha256 cellar: :any,                 arm64_sonoma:  "df90a21f7c6c10f0eccf11175f5a53ffc935b193b07cee1ed81c81724e6bd34e"
    sha256 cellar: :any,                 arm64_ventura: "c822929e63ce35a50eaad520ac611f04ff986c60d743979f2ca1cdbb53edb968"
    sha256 cellar: :any,                 sonoma:        "94cfea0cc10ada25a1b5c0eecb19ea862625c211ab0297a692ac36bf99d32a77"
    sha256 cellar: :any,                 ventura:       "488976fa1956986625d0debf1381be0ac2a541003174a1f87e06f904af53a999"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "92aedb873156669a16f4cc41bf5f94756c8bc378ff634fa3dd19d015b185cdca"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args(path: "cratesbin")
  end

  test do
    require "utilslinkage"

    assert_match version.to_s, shell_output("#{bin}yozf --version")

    output = shell_output("#{bin}yozf config get a 2>&1", 1)
    assert_match "Error: There is no 'a' property in the config file", output

    [
      Formula["openssl@3"].opt_libshared_library("libssl"),
      Formula["openssl@3"].opt_libshared_library("libcrypto"),
    ].each do |library|
      assert Utils.binary_linked_to_library?(bin"yozf", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
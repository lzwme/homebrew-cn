class Gleam < Formula
  desc "Statically typed language for the Erlang VM"
  homepage "https:gleam.run"
  url "https:github.comgleam-langgleamarchiverefstagsv1.5.0.tar.gz"
  sha256 "0342babfbd6d8201ae00b6b0ef5e0b181bce5690c703ffae8dd02542e024c4c2"
  license "Apache-2.0"
  revision 1
  head "https:github.comgleam-langgleam.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "293fee21b68b162349528735735d4a5e64dc68dedd8bf4836a35d41d530b1436"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "72a3afa8905d3142685ab9b2af5b8394c8f143b7eb8913cf16121728f0186bbf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "948428cd21bf47aa29c557622cb731aeca67288cb65e2286f1eee97172b2d12c"
    sha256 cellar: :any_skip_relocation, sonoma:        "5a28daf1cf8998d7781aec7ce975f02bca07270f15b53660779321d2e49d86a5"
    sha256 cellar: :any_skip_relocation, ventura:       "f4c8db62793928696d6c8490aa3bc1a39a58038ec23b3b1f95604637bc139924"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff1b2e327d3d7583af5a1ed4abbf306e9e2ca16fb982612925c5b9cde9f49a8a"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "erlang"
  depends_on "rebar3"

  def install
    system "cargo", "install", *std_cargo_args(path: "compiler-cli")
  end

  test do
    Dir.chdir testpath
    system bin"gleam", "new", "test_project"
    Dir.chdir "test_project"
    system bin"gleam", "test"
  end
end
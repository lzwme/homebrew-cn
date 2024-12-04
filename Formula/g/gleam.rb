class Gleam < Formula
  desc "Statically typed language for the Erlang VM"
  homepage "https:gleam.run"
  url "https:github.comgleam-langgleamarchiverefstagsv1.6.3.tar.gz"
  sha256 "2d73320ebe7ea7154ca63f08f70b19de8e283bd198b5ce58fae19c01187e65d6"
  license "Apache-2.0"
  head "https:github.comgleam-langgleam.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "29aface473ee96ccb4a9c712134f863978ff1f22bca4b9d86a5a40ca8f761a10"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1d5df8619f337ce4997aac1bfc7f5996d77fe81360907015448c95f4d69a2e6c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "91b42381d1a44e337dfa25597bbdf94766a3e58bfc54ec64930603964d8b3543"
    sha256 cellar: :any_skip_relocation, sonoma:        "776e9d7aac46cd581801239b6818bd1fd2468ea056c9a1e4607677f7f82d6836"
    sha256 cellar: :any_skip_relocation, ventura:       "64fbf7a3b89561fb503f65027cd5fcfa9f8d4003fbc09c9763c1df8e2e3f689b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd6e6dda3a2d8209aa7d1b15f10efde65c41f9b1b7b5b358f83b5da926d38099"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "erlang"
  depends_on "rebar3"

  def install
    system "cargo", "install", *std_cargo_args(path: "compiler-cli")
  end

  test do
    system bin"gleam", "new", "test_project"
    Dir.chdir "test_project"
    system bin"gleam", "test"
  end
end
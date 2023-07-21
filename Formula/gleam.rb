class Gleam < Formula
  desc "Statically typed language for the Erlang VM"
  homepage "https://gleam.run"
  url "https://ghproxy.com/https://github.com/gleam-lang/gleam/archive/v0.30.2.tar.gz"
  sha256 "8e2154cf0a812edc7e52f19197cd1950bdaaa47a673659101729084d3231e44d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "202c60eb230db6f9bc8ca8eefdaa276fb56def5895a21136ef32a3c44eb1bdda"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "351088750ca8b694e84e945999f9a05f7fdd298694ec7b621ea92eab5d21f060"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9ee2d13679f561366a2e02931f1b1aefd96fb2d006edc996f3a3de0db88580e3"
    sha256 cellar: :any_skip_relocation, ventura:        "e52fd8d9ae82ca122d7148bf279273535154dd64f264570e20c009b703e64949"
    sha256 cellar: :any_skip_relocation, monterey:       "90d2a741416f0bc54af2ac0b41e7196af1ecc3d0dc60d03eca4ea802212132d7"
    sha256 cellar: :any_skip_relocation, big_sur:        "410534acb95c1369b38ebda555422d9029794eae0bf7c6931ed0ecb6b67f00b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9f10978c7c1d946f3918e1cf513b4c395da9f9a8c8414e0d98b32e7e61e2be84"
  end

  depends_on "rust" => :build
  depends_on "erlang"
  depends_on "rebar3"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "compiler-cli")
  end

  test do
    Dir.chdir testpath
    system bin/"gleam", "new", "test_project"
    Dir.chdir "test_project"
    system bin/"gleam", "test"
  end
end
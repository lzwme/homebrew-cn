class Gleam < Formula
  desc "Statically typed language for the Erlang VM"
  homepage "https://gleam.run"
  url "https://ghproxy.com/https://github.com/gleam-lang/gleam/archive/refs/tags/v0.32.4.tar.gz"
  sha256 "60aa2e873168af2c6644a81b193b46521d44bc7d16d0b33ffd23ebe4d7872f6d"
  license "Apache-2.0"
  head "https://github.com/gleam-lang/gleam.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1bef86c6ae1f18443448fcabb6e838e578bb90644567dfce3fd9f207086e3957"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6f274214e2719d43d10e48b157bb4400b0df42fe7eef65586654aa124429361f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "422ec246ef1db9c25f0bb12248ccc491a967f54e25785f3c2b4f96827ccb77c9"
    sha256 cellar: :any_skip_relocation, sonoma:         "d7e20e4894fc7a8c2567633bc074aa2bfc76e7998b3d8f1cee14ad0ea2c8eced"
    sha256 cellar: :any_skip_relocation, ventura:        "6900b7284fb4f3b8e8cb27173ea19ee07c2a0dd0a55378a8066b635e33fdc332"
    sha256 cellar: :any_skip_relocation, monterey:       "bb595c8cc929f86e4c22e0b9daabd7917d4e8611ea63401032086cf8652a2d22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5875c04bd6d70f63b42753426603874c336c19aa26fcd2805e19834a262f5541"
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
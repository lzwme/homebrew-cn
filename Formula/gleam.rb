class Gleam < Formula
  desc "✨ A statically typed language for the Erlang VM"
  homepage "https://gleam.run"
  url "https://ghproxy.com/https://github.com/gleam-lang/gleam/archive/v0.28.2.tar.gz"
  sha256 "15ec5e1d0a287a9a22376aa5ffe8a480e2803e4c6ad6485da57fd5a9d345a671"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f74737f976accaf0dc308da2cfc43397254ef65fcfb591d9bf73f4d540579002"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dcb9bec871d1833ac19fbf717e02d64b7b5b547299a56ea8ef9b5d84c84267b1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bde2e8f750fb16c8f3389b309f73cdb953c19b462283decee02429999b5507be"
    sha256 cellar: :any_skip_relocation, ventura:        "6cdc6cc3b279590ae98ec1fb7c1d4c54c273d283875cfbc81e192be93558d71a"
    sha256 cellar: :any_skip_relocation, monterey:       "b69db938866d9b4613daa4ece08eb23a488a26b3552c268f526e8ee0b9ab2284"
    sha256 cellar: :any_skip_relocation, big_sur:        "ba93f6b31dd375657031598cb7c1e0bd30c396c7c1285448d7d831bc4215557d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "138767fd4d747bbafc0f31c53e25152ec3222b3bf87b394e2c465f8c3088f1a4"
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
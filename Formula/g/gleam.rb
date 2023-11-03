class Gleam < Formula
  desc "Statically typed language for the Erlang VM"
  homepage "https://gleam.run"
  url "https://ghproxy.com/https://github.com/gleam-lang/gleam/archive/refs/tags/v0.32.1.tar.gz"
  sha256 "c81f4a8278002c6172283d08234ab2a24ef19e2633e3bb81be2aca0d237398ff"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "52ea501a7b84032afbe9abb3b8dc3b91f209af3612886c3cc763ac76edbb9cd5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7cadb9c00457a3b1fa4931676b98f97dd772ea82cdaef2e03076bbfd24436f3d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "786ad2f200a41645af32d9da8db8e2bee74472fac39832261339079212a5937a"
    sha256 cellar: :any_skip_relocation, sonoma:         "f97bd1701727c331a113f247fdde938725d57d8631a48f93a9ebc60c6141308e"
    sha256 cellar: :any_skip_relocation, ventura:        "97173127e9b38755707d5f1b05c033c3c5a74e9a198e39ae290b4d454b7376b6"
    sha256 cellar: :any_skip_relocation, monterey:       "744d06f9fba98b0f918712b4f56d2dd067c3725f34bd9910333ba59baa88bbb1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "45708b8a3382593cde2e387950bd7abdbeb737694750961727771c00b7ba94e4"
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
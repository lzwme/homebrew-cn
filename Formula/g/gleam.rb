class Gleam < Formula
  desc "Statically typed language for the Erlang VM"
  homepage "https://gleam.run"
  url "https://ghproxy.com/https://github.com/gleam-lang/gleam/archive/refs/tags/v0.32.2.tar.gz"
  sha256 "46581d9a62312a40923eabc41a3c52a2da36f986b2529692d7dd2b41460fb13a"
  license "Apache-2.0"
  head "https://github.com/gleam-lang/gleam.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4c5c45c184713fa01b33cd2b8b406ca23b3020782a2d796e187101097326d731"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "74edac62954633ce47e71645cd2b7893ce88bfabbb063c67759569593c563916"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "23e5caa4d549bc21d134d499867a342cabaf0fcf32cf0c1e9079cebd918ea817"
    sha256 cellar: :any_skip_relocation, sonoma:         "43ee88757f2f0be16d26b84503b7db3acface053b7095826e3b3e136a68d6be2"
    sha256 cellar: :any_skip_relocation, ventura:        "bed700b017898eaa5efbbabfb3e82440c7baa552dbbf967e855c6a9db63d98a6"
    sha256 cellar: :any_skip_relocation, monterey:       "3b64ceb877d1d52bb2b9bfaf58a41854ee4eab50f2f5a83017267a2ae1e11f20"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fe4612738d95a09e10a9f794cc972f2ee4ac99c50434aa5e5eea1680b0ecfcb9"
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
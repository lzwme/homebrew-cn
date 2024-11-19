class Gleam < Formula
  desc "Statically typed language for the Erlang VM"
  homepage "https:gleam.run"
  url "https:github.comgleam-langgleamarchiverefstagsv1.6.0.tar.gz"
  sha256 "e4362bca4e82cfdbbb5a09f2bfa9a67fe6d766f893c6bed8852694aca9c30bc9"
  license "Apache-2.0"
  head "https:github.comgleam-langgleam.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1fd85a8cc0275e6ea48acf214183e9b859ee2948ffbbddbbec52423d97b3ea77"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d6b69fdb4b71a1797fa10a731d2433284a359e51effc628a30df63fa732d5395"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b1fd8841f5e010c904f87fa675ce8136ddecd98b1bada1f47f076ac672e4b09c"
    sha256 cellar: :any_skip_relocation, sonoma:        "9d06b86586ee4cd8fe1b18983de304db361465c3b521a9fcfcbc080ee27cea94"
    sha256 cellar: :any_skip_relocation, ventura:       "c22d8f6ae91c4cc8fb6a38b48754af41be29a04c57249554da04cdf19cb89791"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "04b84c9ecb9371b3e8aa33bbd2c24c75b8679cc007e2d717c395d378ec20e020"
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
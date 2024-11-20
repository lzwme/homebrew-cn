class Gleam < Formula
  desc "Statically typed language for the Erlang VM"
  homepage "https:gleam.run"
  url "https:github.comgleam-langgleamarchiverefstagsv1.6.1.tar.gz"
  sha256 "86bdaa4b7803230bd434044e0632f6d31246a8514fd68d10c3add9dfff400544"
  license "Apache-2.0"
  head "https:github.comgleam-langgleam.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "84740cac7c3dac5dd0a205f086583c6b426c8d9cbdbc0907e01453cc371a7a1e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "612498f5b8b28c059b59304ff85d4c50b74b3ef985a32c02d102561d6153fc67"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f7712445491215f929ed9bf729da333a8dbabf69d69e117f20d9bc74dc74807d"
    sha256 cellar: :any_skip_relocation, sonoma:        "cd8ea45e615c2c7d469faac0091e129817716fa2c56742e61dbe6ebf54441435"
    sha256 cellar: :any_skip_relocation, ventura:       "17e7a0b7cc7e8117492da196cdd75daceb299967a965f6360bf598db26055a96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eb8e8b1a2a0e59d243b9a6cbe860c167b4ef48770a953964e2341a0b35cec15a"
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
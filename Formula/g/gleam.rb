class Gleam < Formula
  desc "Statically typed language for the Erlang VM"
  homepage "https:gleam.run"
  url "https:github.comgleam-langgleamarchiverefstagsv1.8.0.tar.gz"
  sha256 "296a04e27c8df16750c36d4d167646967a2ed71e3e2e1ae6e724c631a22c99df"
  license "Apache-2.0"
  head "https:github.comgleam-langgleam.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8b960ee9e49c6371cc7e122e259be379bdb05826723d268f16f945cfabf591a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "357752dad8aa8c70bd5784782085f1593c8c6be6d1259d881f1fc00b64120516"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ccebec1d302d065b3e0d476752bbac5e412d98d377ffcfb96e1a437b5cb8035e"
    sha256 cellar: :any_skip_relocation, sonoma:        "7b49dbb26f916332d960f6946fcdf6b5d635a051d3b58345b336b9e3926d04f0"
    sha256 cellar: :any_skip_relocation, ventura:       "6fd8ba2f9b901676ab423ab1a2fde3a4074381b2526371c2747ace0692b9aa49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "43f0739d4b43ce7027112564c2110ed786266f0debfc595f50d703f9ba733156"
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
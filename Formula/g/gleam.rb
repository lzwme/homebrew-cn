class Gleam < Formula
  desc "Statically typed language for the Erlang VM"
  homepage "https://gleam.run"
  url "https://ghfast.top/https://github.com/gleam-lang/gleam/archive/refs/tags/v1.15.1.tar.gz"
  sha256 "0583be154e097facff4ae718b226b5f112a0d105261bab96ee95902038dae16a"
  license "Apache-2.0"
  head "https://github.com/gleam-lang/gleam.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1d63e4d442c54cf541a9cf894b27af696ff9a714f9b49ee9b8fb47c8952e3788"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1fbb43146f299f0868903ce7262046fc5e9a7b2b8d3f5b06c32b7811ec9f2fa3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0380f8d05e31337d22e6442468968af227d56da7c2fd89946b060102972fde8e"
    sha256 cellar: :any_skip_relocation, sonoma:        "3157932080de4d8a4d3c842c84844a49ce6ac658714d133374d892ebfde19c84"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a1905c9981421f8fcacd29aa8fe5047d23496f8e4816c6802b3a477e5d7d7e52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0895fa61e4853bfeca99b77711b090abb0d22f60a098c9944cf0150b573aed79"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "erlang"
  depends_on "rebar3"

  def install
    system "cargo", "install", *std_cargo_args(path: "gleam-bin")
  end

  test do
    system bin/"gleam", "new", "test_project"
    Dir.chdir "test_project"
    system bin/"gleam", "test"
  end
end
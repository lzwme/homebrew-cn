class Gleam < Formula
  desc "Statically typed language for the Erlang VM"
  homepage "https://gleam.run"
  url "https://ghproxy.com/https://github.com/gleam-lang/gleam/archive/v0.30.3.tar.gz"
  sha256 "6332d1c0fd3a575f0a57fe38092afe09d0a0be1892239eadcc6a27ce3bf0fc2a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a81303054eac818deb35c7b7a6334fe8405bace54483acaf0eef15d7f96cb924"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0028ff9f33be8b831bdb13ae2e39bdff1b4fc4716363dfbb26ccc4be1bdb29fa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c2a85dfa52aba87929f3c9272155c32e28a39e13fef11d9675759aee1f8d99bf"
    sha256 cellar: :any_skip_relocation, ventura:        "ac5449e799da0873efd8d9b4354fd3ccab79ed6ec3a8ac7e8c967b14e9b12340"
    sha256 cellar: :any_skip_relocation, monterey:       "480414f299f6989480078aefbd339318e4b47e07eaf67ca72e3edcfa73bf5ae0"
    sha256 cellar: :any_skip_relocation, big_sur:        "59bd8c639692f0514039cdf0f0b0075a9da064b28746c9a7077008d279d1583b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c7d910ac2beca136499c6ea60e95d9c04b0f50ddb8f36530bc5ae317c36a9fbe"
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
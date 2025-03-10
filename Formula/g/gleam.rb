class Gleam < Formula
  desc "Statically typed language for the Erlang VM"
  homepage "https:gleam.run"
  url "https:github.comgleam-langgleamarchiverefstagsv1.9.0.tar.gz"
  sha256 "ba3121d6e335f086caa5eeaf1caca61960a75f25f60e6d99c7b129d52f12153d"
  license "Apache-2.0"
  head "https:github.comgleam-langgleam.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8daa4b12b8fdd0e90ff238750ec746746723ef7395e43b31753b2e98d95b7429"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3565ea2c12aa3ff4ab0f137ff08839ad687a6776963fb186a0da792a2db524f1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a6cdbe42c0db9e87ab10e258563b3fa92dbfef20020ea8ad9954978955723214"
    sha256 cellar: :any_skip_relocation, sonoma:        "7ddeadab537cb83dd0da419ae08a25b0c6b65224f6ee8808d691ee6a0b91e5ef"
    sha256 cellar: :any_skip_relocation, ventura:       "12131137986c37afe246a61668bb40991a5ca09494d16f7e64d55836489cc0d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1ab435fc91d1a6cb6496c2c03ebf395909e9c874de4967e29cbe2a019cf4975a"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "erlang"
  depends_on "rebar3"

  def install
    system "cargo", "install", *std_cargo_args(path: "gleam-bin")
  end

  test do
    system bin"gleam", "new", "test_project"
    Dir.chdir "test_project"
    system bin"gleam", "test"
  end
end
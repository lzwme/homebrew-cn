class Gleam < Formula
  desc "Statically typed language for the Erlang VM"
  homepage "https://gleam.run"
  url "https://ghfast.top/https://github.com/gleam-lang/gleam/archive/refs/tags/v1.18.0.tar.gz"
  sha256 "a89e5fdb6c56c2063fd8d3bff9e06ac6ff45e102d17da4f9655e79038ef02e89"
  license "Apache-2.0"
  head "https://github.com/gleam-lang/gleam.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9774228058e1ec75ef958ffca0998e87b624b302a3abddc9ff7a2cb6e51cc460"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4986adae91e1db7dd7dff83e1a2bc056c5c2eddbc818e7bd123f6a594b8bef82"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9196324c78ce872cc6ea87423c7cc463ec4f26d290c36a518493f3458d39163b"
    sha256 cellar: :any_skip_relocation, sonoma:        "f52095f69a0ca494b46837b29d32f9e51d0bc99a96b8eccc594f1a9ef412d685"
    sha256 cellar: :any,                 arm64_linux:   "34e04c853c7164e6df27c9e6e284581459455bc52e27048640cdce85172a0419"
    sha256 cellar: :any,                 x86_64_linux:  "93c36805ad7721cca79bdff9eff0cf947883b194471d26a9e68ad0acdcd56bf8"
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
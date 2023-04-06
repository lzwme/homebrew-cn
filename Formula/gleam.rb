class Gleam < Formula
  desc "✨ A statically typed language for the Erlang VM"
  homepage "https://gleam.run"
  url "https://ghproxy.com/https://github.com/gleam-lang/gleam/archive/v0.28.1.tar.gz"
  sha256 "39cac90cf7080c63ccfb8f9d3bd30e610c91fbb7339ab0e3b92be5ad55f3e525"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cb1f6d8ee01a5e85158ea1e3e29201d4bfc3a44c73e6f935f637ebbce740fba0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "da4bb4d40d595f6997e8c93a3ab0c0da8a47dec5d1a3f641d69312a62e3dd08e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9e2945454eeaa68460c0137fabb96a421cad507442e4132700c967cd16f48969"
    sha256 cellar: :any_skip_relocation, ventura:        "9f822c73f255e522266f158b725b76ee35fef459238cec747af86a98c7bd2f02"
    sha256 cellar: :any_skip_relocation, monterey:       "9865fcbe3e35d6f35a36a0612246d80f9d04872a35729b91808caadfe45beca2"
    sha256 cellar: :any_skip_relocation, big_sur:        "7505e0f0d5c120952c95ad70c41b4e8ef475759afedebe031670ef9980aef7c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "31e5bbab2fe67101bb305a6725443268910c75635db6c3a799788689258ea195"
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
class Gleam < Formula
  desc "Statically typed language for the Erlang VM"
  homepage "https://gleam.run"
  url "https://ghproxy.com/https://github.com/gleam-lang/gleam/archive/v0.30.1.tar.gz"
  sha256 "a0001b36d734c60d0b3b5053770d3edb8657adced3d02f98096d0f59be4a3a97"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ce15e6a2173f6a6ff8168105abe4d725fb11deaeb0979188d2fd1ae0d89c17df"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ccdbbb7adfb6444f49f2a101697c3a7fb41de22ad509bd6d2fdd970c24c458f1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b436a6d3b656ce1666853a4446142895a01cf164182b13f37350acf3738656c2"
    sha256 cellar: :any_skip_relocation, ventura:        "786c3d5e8773178c6ebb10a6194245517775d118dc08f3f94c4c9e05d28c680c"
    sha256 cellar: :any_skip_relocation, monterey:       "2cf08f42f0f3cadacc44c9e8d1c60c02efa5a2f41fa0555a3746c4aac8307e49"
    sha256 cellar: :any_skip_relocation, big_sur:        "0b1384ceea91964b9187a1adf16f777520110016b9e23a7db0fda0960c25c379"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bf69831079fea3bca8f33557e26003e4ab5ae8efd76fbbe3f0ffb7c6359c0b08"
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
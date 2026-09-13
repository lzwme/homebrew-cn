class Juliaup < Formula
  desc "Julia installer and version multiplexer"
  homepage "https://github.com/JuliaLang/juliaup"
  url "https://ghfast.top/https://github.com/JuliaLang/juliaup/archive/refs/tags/v1.22.3.tar.gz"
  sha256 "74479b687a914db8c0b7e63c58babdf25f7dff4183d729f576b6e9d59dd30a8e"
  license "MIT"
  head "https://github.com/JuliaLang/juliaup.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9938c749ea726fc8f706f400be831025d40a3835fa69ce77dc5bd724e1b8983a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "97c846abdb00e70dc327266fb8f74ff844b7e519e3b5e6a52d035dd4b2119df3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "18055e7ec73efcb4098cbad61d43e117d75cf1627378ab67655b87337a3e1052"
    sha256 cellar: :any,                 arm64_linux:       "3192d8cd920d36274d59938601e87770a5f71416e4ffc1f82b161e0cfdf24580"
    sha256 cellar: :any,                 x86_64_linux:      "90fab19126ce1d040f3ebb1ed4b7f1bcbec2c2ce6385d106807eeda256daee0a"
  end

  depends_on "rust" => :build

  conflicts_with "julia", because: "both install `julia` binaries"

  def install
    system "cargo", "install", "--bin", "juliaup", *std_cargo_args
    system "cargo", "install", "--bin", "julialauncher", *std_cargo_args(features: "binjulialauncher")
    system "cargo", "install", *std_cargo_args(path: "juliaupgui")

    bin.install_symlink "julialauncher" => "julia"

    generate_completions_from_executable(bin/"juliaup", "completions")
  end

  test do
    expected = "Default  Channel  Version  Update"
    assert_equal expected, shell_output("#{bin}/juliaup status").lines.first.strip
    assert_path_exists bin/"juliaupgui"
  end
end
class Juliaup < Formula
  desc "Julia installer and version multiplexer"
  homepage "https://github.com/JuliaLang/juliaup"
  url "https://ghfast.top/https://github.com/JuliaLang/juliaup/archive/refs/tags/v1.18.3.tar.gz"
  sha256 "0a7f3fba30442ea79eead522805fa2d3dd87bfc177a838be24733e0c1b1657cb"
  license "MIT"
  head "https://github.com/JuliaLang/juliaup.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fd43638eefbd6141ef29fc2ca43050888df8d5305b9fafb8088e5348efd38825"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3902e1530c65c503faee4ee3cdb08bc83a749267d58e7d511d076922904fa48d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "513d96836abb71f5a4d171ec8e775d0b49a383d3107726dc88e85839dd94b96c"
    sha256 cellar: :any_skip_relocation, sonoma:        "f6a236e88ae12ac5397e3edfaafe0a66991cc3c99597bd3f744e7c661702754f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "af6b099f22a9a5b2081a54fbbd92f331b8dff8766eafc2d9924ce948ae262986"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "27239d4df5cfca96d20aa37c5936d1cd989319d93b651700ce6413c10611526c"
  end

  depends_on "rust" => :build

  conflicts_with "julia", because: "both install `julia` binaries"

  def install
    system "cargo", "install", "--bin", "juliaup", *std_cargo_args
    system "cargo", "install", "--bin", "julialauncher", "--features", "binjulialauncher", *std_cargo_args

    bin.install_symlink "julialauncher" => "julia"

    generate_completions_from_executable(bin/"juliaup", "completions")
  end

  test do
    expected = "Default  Channel  Version  Update"
    assert_equal expected, shell_output("#{bin}/juliaup status").lines.first.strip
  end
end
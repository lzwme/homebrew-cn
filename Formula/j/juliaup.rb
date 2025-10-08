class Juliaup < Formula
  desc "Julia installer and version multiplexer"
  homepage "https://github.com/JuliaLang/juliaup"
  url "https://ghfast.top/https://github.com/JuliaLang/juliaup/archive/refs/tags/v1.18.2.tar.gz"
  sha256 "bac7e4985b8bc35dc9fc68a1340ecdc5b4a8861c6afb424d6b769725a70f97f3"
  license "MIT"
  head "https://github.com/JuliaLang/juliaup.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f10d92341ba76ac403869c67be2a208c6fb892cfe35bc21049be7ad3446f597c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ad56cdf12e89ca94072a1e016035319e1065c7808f4bed33fb55c6f763e4747f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ce66a35429706d7c5be346c3a7d66ed574b5e4ecaf8764cb312643a0e162b0ca"
    sha256 cellar: :any_skip_relocation, sonoma:        "e1246ea3a66d65bd6a5f02582854919920ec0b7d3fe5acbe24be3bc79c2b1bd7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d53157e39f05da6f47ae7b60a2ff747e5cb3b48fdfe4cf49d11bf5c82d5cd894"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e8b37e078bbe3699726f9209b950bf86b24f763c6758197d4718643d97650060"
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
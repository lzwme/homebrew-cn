class Prek < Formula
  desc "Pre-commit re-implemented in Rust"
  homepage "https://github.com/j178/prek"
  url "https://ghfast.top/https://github.com/j178/prek/archive/refs/tags/v0.1.3.tar.gz"
  sha256 "a773fb2ea7ea0186e592248fc793494d2640e27225f1490c824942e4ace2406b"
  license "MIT"
  head "https://github.com/j178/prek.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e7473871f21b3e673b5d9b4be3a9c2c911c54c8a06d7e74bb8bf5787973cfd74"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bcdc0ea05145cbdd165db72bdd0227747e1124e6ea0b25aead909c2cabd4ab0f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c077dcec9a72d7f1cde6c6ee695a6e758204792d664da5a3e80d4d5e2bac5770"
    sha256 cellar: :any_skip_relocation, sonoma:        "4741fff77f2855fb34661c878561de8521425bf93bcf8422043cddd1f00a27be"
    sha256 cellar: :any_skip_relocation, ventura:       "d5d963d3d6b2334fb0703a6338f4d543f69e0bc3a0e9c486caddde7ece6431df"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e473d1b0a4696dde987e8ed179611432edef2303bbabd94d4436482ebf441898"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c631bdf21721a8399bb9aee43b76f66ae8b6eb437ff811599806c2a16767449a"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"prek", shell_parameter_format: :clap)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/prek --version")

    output = shell_output("#{bin}/prek sample-config")
    assert_match "See https://pre-commit.com for more information", output
  end
end
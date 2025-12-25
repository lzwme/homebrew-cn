class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://github.com/vinhnx/vtcode"
  url "https://static.crates.io/crates/vtcode/vtcode-0.52.5.crate"
  sha256 "bda55d9a6126d2408320c9500486e61aa3ad097c3dc499984cd6e0b981bb7d7e"
  license "MIT"
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "76abbaa305121d6e8220c9465a3ff961526de4e3deb3eb17c6c1483581ec1819"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "acfeca40c8f92cffabf03dc437a6d4c5bb5fc7ae32e41a0d39ac9e903de96dcf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "895286209acedf4bb34d1d79bc3ed3c1c844f443ffcfb51707fbb2d33e58008d"
    sha256 cellar: :any_skip_relocation, sonoma:        "144a5820bf71d520e0933268a95c84968a1fff8728be6cfdba28e598bd847428"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ea04b4bb82ae348fdce22da229fedcb00d2d51b719c9c979e72ff76548f1f4b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "df54530f8a8a946e336c99d7f4748b999d95544a3287a00c0d729eff1bdfb5d5"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "zlib"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vtcode --version")

    output = shell_output("#{bin}/vtcode init 2>&1", 1)
    assert_match "No API key found for OpenAI provider", output
  end
end
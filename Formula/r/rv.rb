class Rv < Formula
  desc "Ruby version manager"
  homepage "https://github.com/spinel-coop/rv"
  url "https://ghfast.top/https://github.com/spinel-coop/rv/archive/refs/tags/v0.4.2.tar.gz"
  sha256 "9588cb0fbeea0921eb4d0cb8b4ad8cda0ca6b2e39f82b1adac6eb8109ee1a7bb"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/spinel-coop/rv.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "500c237db2fc10bedfa5f338d0bc01efe87c6b6828af507dcfab89d2abfdf058"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9436bc4b43c895d6eab19cfae227b3fe3671697b5639fa9a2fcabeb32bfa1c10"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "196d5e373ba22c3cba3c83ccdbcf8a5249210b4779efee149a5ebb5eaf58e28c"
    sha256 cellar: :any_skip_relocation, sonoma:        "e361dac5d908a5ba85e18986dfb1ff526af01b548ec4d170dba273d966425ba1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "71766529b9ea1577cf3092252036bb1b875a41ebd0b1d31c41fa57993ee71923"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7c5cbf834964691c7bbad781e29658f8a088a5247b5022ca2634528911172b31"
  end

  depends_on "rust" => :build
  depends_on macos: :sonoma

  conflicts_with "rv-r", because: "both install `rv` binary"

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/rv")
    generate_completions_from_executable(bin/"rv", "shell", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rv --version")
    assert_match "No Ruby installations found.", shell_output("#{bin}/rv ruby list --installed-only 2>&1")
    assert_match "Homebrew", shell_output("#{bin}/rv ruby run 3.4.5 -- -e 'puts \"Homebrew\"'")
  end
end
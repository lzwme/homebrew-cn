class Rv < Formula
  desc "Ruby version manager"
  homepage "https://github.com/spinel-coop/rv"
  url "https://ghfast.top/https://github.com/spinel-coop/rv/archive/refs/tags/v0.4.3.tar.gz"
  sha256 "17f6a3ee9383236993a7f43201ac55642e863b959426b4980bab669ceb7f4174"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/spinel-coop/rv.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "84f0e681b9d37b0677e8c04eb039d74c7d96ccbfc6078cec17fd9cc362aafd9e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0e4ab615cd57b240b2b578d3fc24fded5fbddf4ed28051d568c31ae0021977f7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "61735c434d247a79d431a9b39e00e9d145510fabd159b13b08a0ccbb933947b2"
    sha256 cellar: :any_skip_relocation, sonoma:        "a18dc149176da5e2e9ae86840c0f825c89d0dc9a13d1792df7c99a7dabb90fda"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f2fe1fd4f18a9d165192ab3e227f6bd3e65a54956961a5ab8f660a53acde8cbc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc62da14aa7c7677f9ff61dce1fc42d075eb06a41644f5bee2a9cd1c62140985"
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
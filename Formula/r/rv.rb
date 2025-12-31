class Rv < Formula
  desc "Ruby version manager"
  homepage "https://github.com/spinel-coop/rv"
  url "https://ghfast.top/https://github.com/spinel-coop/rv/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "4b498e776679da822a67e854857cecdddf5d012c9cfc03a3f60c3b0a6ca0ff4e"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/spinel-coop/rv.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "69a1aaba8e5870210053774505177835368aee1047b9eb569e219a301350dd15"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "370e3d95cf4843aabcc652ea5da4da8195749bba546ece53b9463e883bc13041"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "17ce2f1babb5482bda680790c286e716f8ab897180c9f21194ee195fe7ba4bd1"
    sha256 cellar: :any_skip_relocation, sonoma:        "660155f3797a422d63564ea54e678b1c9a7a3afa392ad8157d2cf26184c490e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "561113a52cb89e1a25a4fb67c1e9038fbb5db64298b5f144ee8e3e6f92753919"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe184c82a73ba951e49c2f262b5df81681b8ce24114b28edbe71f0df357e0e25"
  end

  depends_on "rust" => :build
  depends_on macos: :sonoma

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
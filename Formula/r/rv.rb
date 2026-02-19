class Rv < Formula
  desc "Ruby version manager"
  homepage "https://github.com/spinel-coop/rv"
  url "https://ghfast.top/https://github.com/spinel-coop/rv/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "3315f6ea6436222ad9d4e8959e1baddf5a764fca3568d45451513ef0846c2d26"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/spinel-coop/rv.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "941030ab5e2e34eca8892dbb8ed653e966fe65078de41b93afd2863fadb5e5d8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5cf88a2851589e1804e1504fd5001bc5907bbd990f0ce6cad8d8c8b5b85f6a6a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3d2e2d3f8a278a8e0f438084586e69189d32e7af3f70494305a73b54a6f16b80"
    sha256 cellar: :any_skip_relocation, sonoma:        "ce8ef10698f9a1fa66bb0965ad7f8e755b7fba70d6c2b4c82ce5cf075a15f775"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c5345b418b2a0eb9f3436fe1995ee28b089070a10a51e16b6d226ee80dff81a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "26bafb447445a6abf32e5fddf86150c0f06637e50da4dbfb54425d3d0ad9a03c"
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
class Rv < Formula
  desc "Ruby version manager"
  homepage "https://github.com/spinel-coop/rv"
  url "https://ghfast.top/https://github.com/spinel-coop/rv/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "8bead2252779000d56f115ef599dda2371802cb6bb357b1560fa51be0173a30b"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/spinel-coop/rv.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4e876d443519a58e8e50517f204aebd087c1a0a7ce12508e857d7f09547425a0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "92c32f80f9e3e4146fb8f3bd40a4d43e2a1b1528650b3eac9f79fadfe54662d5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8cbc5b8705b0938e9d21998425411679f1160133c5c4163d4c2cc03bcc167eb7"
    sha256 cellar: :any_skip_relocation, sonoma:        "40920ec71a5a8dedb022f9c97f15951ab04907626974fa2963d1b7eec66d960e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f43e1d43e89a23b837b5e7c7446393a19764c66c353ddd9696d3f40613444b49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7a6fb185e7b0915ee02f5ee1a75ad6ae77b3ae4b2e767b95c68f2577c5571563"
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
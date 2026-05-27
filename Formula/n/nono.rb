class Nono < Formula
  desc "Capability-based sandbox shell for AI agents with OS-enforced isolation"
  homepage "https://github.com/always-further/nono"
  url "https://ghfast.top/https://github.com/always-further/nono/archive/refs/tags/v0.58.0.tar.gz"
  sha256 "214d7aa9756219e6e5ca2e5db2ce9e6754ebc74c4773cc91efc95975283f8e4e"
  license "Apache-2.0"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bf4a9dd8a1838a7c14009197fcf2f48af6ee6ee07790a127a96f52a2327d086b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6777ff1c5884ed56e9131f609bcb8a5cc3c873943f25aaabfe7e79283548e62e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b099dbe0ad3657085a1c6f1912a5d97dc7293d7d4d4f62ba37841ac7899749bc"
    sha256 cellar: :any_skip_relocation, sonoma:        "814e64e504035757145c7eacb17ca22dc169360f7a98c494d60b409b46fb099c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b4fa720faca56018e9e8ed68792a8acf47fd558887249666d11473909f6d506f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "74a4d3aa02ca4ea713176130dd5aaa9b7b7775d6b3649e21255657ead3986a00"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "dbus"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/nono-cli")
  end

  test do
    ENV["NONO_NO_UPDATE_CHECK"] = "1"

    assert_match version.to_s, shell_output("#{bin}/nono --version")

    other_dir = testpath/"other"
    other_file = other_dir/"allowed.txt"
    other_dir.mkpath
    other_file.write("nono")

    output = shell_output("#{bin}/nono --silent why --json --path #{other_file} --op write --allow #{other_dir}")
    assert_match "\"status\": \"allowed\"", output
    assert_match "\"reason\": \"granted_path\"", output
  end
end
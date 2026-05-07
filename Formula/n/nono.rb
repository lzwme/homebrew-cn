class Nono < Formula
  desc "Capability-based sandbox shell for AI agents with OS-enforced isolation"
  homepage "https://github.com/always-further/nono"
  url "https://ghfast.top/https://github.com/always-further/nono/archive/refs/tags/v0.47.1.tar.gz"
  sha256 "a3d965438fae0947b398fe9bb8d28af46ab1b0d32f548093f6ec44aabf7f1dfe"
  license "Apache-2.0"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ac8932b37062e1347a30d264d0e5c229286c09c5ecae89d2614f5dae75446aff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5553ce2c33d662b8afffdd116c6bb98cd068d98f89db8384b9ab06081d838f80"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fe7ab5e083dcf9d0f12f3790ebe311dd3964bbb6d5adc2032a10612619bc472c"
    sha256 cellar: :any_skip_relocation, sonoma:        "9ee155823c58936767f110357fd934b2612c20843d9b5c979ea1f06a225e25b7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "da5944ab7edeeb13e9b0d65ae7244d0e654beb4ead771bc74130e151647dfd1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1693daa27e13bb2a2279be680f5f4b506dca107002a97f37c2c58982b9b83f47"
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
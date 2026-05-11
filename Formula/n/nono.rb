class Nono < Formula
  desc "Capability-based sandbox shell for AI agents with OS-enforced isolation"
  homepage "https://github.com/always-further/nono"
  url "https://ghfast.top/https://github.com/always-further/nono/archive/refs/tags/v0.52.0.tar.gz"
  sha256 "471de9cf649b65fe77cc6a98384d2c8bab7f80208a375adf06eac572f7bf0560"
  license "Apache-2.0"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4c69c084c67257c1ac48d0d20f89b511b3c6ae948c821d1d70b8ca592bb4bcda"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "62b82c2efe1139d75aadaeefd458a9f6e6b73fa593daee0052905533f8ff9f60"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d3143344a7bcac6d72152e13e7cea1aca8bbd9aa4e2bfd3aa459ef0733504eda"
    sha256 cellar: :any_skip_relocation, sonoma:        "b50b0174123087ee1f66ca9287de627f759c2c62e9d1452fe7a00160048ddf58"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a83a58a07ae78ab7e06c99980d4f966371c8dda9a41709b83fa29e971ddcfdf9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a91b29f80bb7ff3bb23d99a25a48e4df73757652f29b26f7ba7f8d08dba8affc"
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
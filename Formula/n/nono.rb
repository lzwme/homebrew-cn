class Nono < Formula
  desc "Capability-based sandbox shell for AI agents with OS-enforced isolation"
  homepage "https://github.com/always-further/nono"
  url "https://ghfast.top/https://github.com/always-further/nono/archive/refs/tags/v0.37.1.tar.gz"
  sha256 "6736c5254c33e2cc63347ad61f772ab795201bfabbd2202c07d4cf91b4e93c97"
  license "Apache-2.0"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9b5e98b5a10a6427ebcf155a3096915aa02387c2bd6694efc41936c255e5c051"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b09580068f3912f66ea7e8091934d4e5faeb026d27ca35f9f9d1460bb7ca8249"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b9d500aaaf05659f9b89b336fd59a4705448be4cdf3c42b03146ac8a87347dc2"
    sha256 cellar: :any_skip_relocation, sonoma:        "3c8d944dd6e6f0507b7fbe2767e9317048a88adf9305a12b3ee6071743eff5de"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1b384d61f99b148ffb4808f0960777a11b32994a0fb413ae4e544f94614670de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "84752d435d73b618b40c0b99eeef301a99992a72e69708b3a1d9f776188023eb"
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
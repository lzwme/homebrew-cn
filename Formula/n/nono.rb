class Nono < Formula
  desc "Capability-based sandbox shell for AI agents with OS-enforced isolation"
  homepage "https://github.com/always-further/nono"
  url "https://ghfast.top/https://github.com/always-further/nono/archive/refs/tags/v0.37.0.tar.gz"
  sha256 "65b1bc2d18b83d5ebc7985bd76302f6b65a877ac09d84236ac67417eb8ca8f68"
  license "Apache-2.0"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f808f7e07f301a12fab8c506349d9dd76c30108fd11d2ccc435e438e080858e9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "26d1c3d4f3e909f6e689b66b1424b089132004d190b36295ff2a5f1d621f8c96"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6f5604ed12144e0fe0f228e28c75285569585a94159e109381a88dac5db385cf"
    sha256 cellar: :any_skip_relocation, sonoma:        "e813a558c9e606678f8e80ce4cdb26eab12d8879b4dea8b35cfbb60eecb5e337"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "59350671c3c82d7fb153b663071b79b63f8cbea8a77d42acde567ca4a6315b8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f47e335a74f3bb78e8987897ea7d13c0659d1a388dc6481a8f5f4bbd4b2e3d43"
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
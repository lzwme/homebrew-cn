class Nono < Formula
  desc "Capability-based sandbox shell for AI agents with OS-enforced isolation"
  homepage "https://github.com/always-further/nono"
  url "https://ghfast.top/https://github.com/always-further/nono/archive/refs/tags/v0.51.0.tar.gz"
  sha256 "f93272edd8eca196f2d84e7e3ff3e1c7e894a8d76d208958b57d17250f2423da"
  license "Apache-2.0"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4a99a0ede84e611974fd4c383251991be51ac7119a54dca73e5f0cbaf8b95386"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "521708b0483701aa20033807e980fb5f8fb082f55a16ea63e716256c90792a7a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e7458fbd5bbf1555221100e269e22c15c1df4fb3fde8528a26b3b7e9f118b259"
    sha256 cellar: :any_skip_relocation, sonoma:        "5d440a83eb8d84c174875f95ce6342d570a7c483dadcd8915ad140c8990b21c3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d5043a5d60540907c3c2c4b77cfa0c54df51605f2bc7902f33a203cef1560e9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b4b5b14954f7aa619448775c535c9aefec087572bc219fa2212ab5aa1e3f3b9"
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
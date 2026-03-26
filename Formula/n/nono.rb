class Nono < Formula
  desc "Capability-based sandbox shell for AI agents with OS-enforced isolation"
  homepage "https://github.com/always-further/nono"
  url "https://ghfast.top/https://github.com/always-further/nono/archive/refs/tags/v0.24.0.tar.gz"
  sha256 "a6e37be7e31404e3988f01c01ea6d3713ac7617ce5a4acd63ac39bfb9e1a69b3"
  license "Apache-2.0"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a7bee898d5e27ed1753ad12c8582652ecbffe380ea9a4bf9f0eff3c2209f675a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5d1850765f5014fdcedb077d1f7167b7bf5f5ce842368b88d74f01ffd35f97f3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6dc662b068b6a787fda532bd822d20880f192ee71f0a61f29d57d68b61978799"
    sha256 cellar: :any_skip_relocation, sonoma:        "f351cd3759ddae80c79ac4b0d680c92481d8efa864a50553a6a704b1f9ff1925"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3f26cb2de569636e8cd9b20ec208be96ccf12423448662004f7e71bc02ddecf1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f67ea51eecc1b44f26b95d16f4bfcb99a9af7e59ad0d908a6a7bb3ca00cba9b6"
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
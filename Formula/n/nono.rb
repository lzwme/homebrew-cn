class Nono < Formula
  desc "Capability-based sandbox shell for AI agents with OS-enforced isolation"
  homepage "https://github.com/always-further/nono"
  url "https://ghfast.top/https://github.com/always-further/nono/archive/refs/tags/v0.59.0.tar.gz"
  sha256 "f5da309b3eef337f60040d4fa5c7fe4a606604dc16bf0ea8cbd34f1a96f8d427"
  license "Apache-2.0"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f43a8c69277d800b10be5e1b2fd33364cac649de6e7b58302c0515389a85c154"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "509eb064655c961288a329cea09a9d9e943183bd5d5c8176e3f6017f33fc69ce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ec7e59589506d00f77aaf182f78d89a0387e3b8d5cc5bc0146667b9022f87f50"
    sha256 cellar: :any_skip_relocation, sonoma:        "5e56d5f9817df0cb6b48c59b8217cd08897cc8cf4a5dfd2080d2ad7b49412ae3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d19ebcdb623806a39383ae40107f836743599949fa746ad83d771744b96ce047"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d9717c8358713999315539f033b1863de4e47ddaee692c3b96978966240830a"
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
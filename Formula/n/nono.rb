class Nono < Formula
  desc "Capability-based sandbox shell for AI agents with OS-enforced isolation"
  homepage "https://github.com/always-further/nono"
  url "https://ghfast.top/https://github.com/always-further/nono/archive/refs/tags/v0.55.0.tar.gz"
  sha256 "21cd895c511c3cc7a3c04ad67e8c9c859eeed275d02cb72c6a45598e8cd69683"
  license "Apache-2.0"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6758e25c88399d5086209ad55232fb7d408bf834670a889cb3cabae8a83f3403"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "75d49f9d405786ff4386f60b1ab09be3bb8fa6b472a00644698a3d24d2115bb5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b71035634c0d2abb5d61cc32473fd664531baaf546ee09de44f1ee2ffd509b1d"
    sha256 cellar: :any_skip_relocation, sonoma:        "14bbdf1ccdf2c1c1375a23ea96bf9cd45aff274e6f72e7be666582f16305beb5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3b16229772a801387c32851bbb4fe1afc5fbbb26bf29427a7e7b8fca67c7843c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b84368cacd78a4230e6326f4a7fd475b908b3b746bfd673ece6e81a949b08ad"
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
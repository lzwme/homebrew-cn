class Nono < Formula
  desc "Capability-based sandbox shell for AI agents with OS-enforced isolation"
  homepage "https://github.com/always-further/nono"
  url "https://ghfast.top/https://github.com/always-further/nono/archive/refs/tags/v0.17.1.tar.gz"
  sha256 "7ed15078a59192b94d62aef961cf22e2345bbc86856e187434266d4091edf321"
  license "Apache-2.0"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "732854cb8b8e74d0705e3d6fbb0be3262d4a71792cf92bbf02e192a8f3c13521"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6387811de1dded719649afd089de618c190fc0bff8a41ee2bd85b1950a0f6095"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cbd621da9c7ebdfc52d5d911461df50124703a3c254f8bb80556855cd95d8d95"
    sha256 cellar: :any_skip_relocation, sonoma:        "278e1340a00926ca9343d6e56b30d2bae0e30aec44eef74922d5c0eed5100bd2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d5e1500f4c12431728bdc1d89c3bcc664ebd43f9fadb6b2f37595141e2b3b75d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "06adaaa871d772d11b6157812692a868edfafd4a9b6ed036a25e5a4b2fce2088"
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
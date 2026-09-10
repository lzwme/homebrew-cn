class Nono < Formula
  desc "Capability-based sandbox shell for AI agents with OS-enforced isolation"
  homepage "https://nono.sh"
  url "https://ghfast.top/https://github.com/nolabs-ai/nono/archive/refs/tags/v0.76.0.tar.gz"
  sha256 "fe7dbee8d20387cef2e0f0dfbea82bd82790aedd11eab283ce497168a8f6e817"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1d3ff4bffed28fa59574e3fcbebe2ac44d5b933937a02a1c8dae364bbc79ec33"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e8a61b87d81a4c8b3b8195de9c6fb8ddcecfcfefad9a8f44dbd8cf60992ce2fe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "09516484e2db51c5e491da8fd6c4f54baef77f927047aa3839a39cc54ca15be4"
    sha256 cellar: :any,                 arm64_linux:   "8e648480e5c4abf900a50a03f70c82a9906d2ae028e47f00b12d82ab9db3b9d4"
    sha256 cellar: :any,                 x86_64_linux:  "c0fce8ed41b6d5e654d61317355210bb2c20c5cd50e86f8ae00f21b5b703ac9c"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "dbus"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/nono-cli")
    generate_completions_from_executable(bin/"nono", "completion", "--silent")
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
class Arf < Formula
  desc "Modern R console with syntax highlighting and fuzzy search"
  homepage "https://github.com/eitsupi/arf"
  url "https://ghfast.top/https://github.com/eitsupi/arf/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "cc745c4a2411c9eee3eaeef31c70f7ebed75e28277624b95d602ac8efc068f93"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4c6fee3a60418689a75375d5e46397c63d3e4e6b905be816844323444a90ea12"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eb6001a1eff7057bdd93be6c91558138d30072ad0fce5d7e5f55131a57373650"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "692484921f626ee7cee73d9c1e7338076d36b888afedb12672bc3b1c93376e95"
    sha256 cellar: :any,                 arm64_linux:   "d7a7d8292246b79e1b0aa93ca63d77e8e9275435a75ecf54330e6bc8533890b8"
    sha256 cellar: :any,                 x86_64_linux:  "dbe08b6597f200795d7750f518bcb89da09c20755fc04c3bc8d7a3ff0084d52d"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/arf-console")

    generate_completions_from_executable(bin/"arf", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/arf --version")

    system bin/"arf", "config", "init"
    if OS.mac?
      assert_path_exists testpath/"Library/Application Support/arf/arf.toml"
    else
      assert_path_exists testpath/".config/arf/arf.toml"
    end
    system bin/"arf", "config", "check"

    assert_match "history", shell_output("#{bin}/arf history schema")
    assert_match "sessions", shell_output("#{bin}/arf ipc list")
  end
end
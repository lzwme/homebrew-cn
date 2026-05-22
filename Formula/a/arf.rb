class Arf < Formula
  desc "Modern R console with syntax highlighting and fuzzy search"
  homepage "https://github.com/eitsupi/arf"
  url "https://ghfast.top/https://github.com/eitsupi/arf/archive/refs/tags/v0.3.4.tar.gz"
  sha256 "59c8c3e9fac13d47260771dc977c33c820a0a7a5704491a73173b6b086e9d892"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6b5929e282abb09a56e1449c39708d8e116885b799950f765f9e798c3529f123"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "be53c5d1e054ca538bece9fe816df309424b3393e251617e3f7ddef8a2cff404"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a0cbab213582c2bbcb1a3aef3456e76f13a527f03ddb0006a43191a890a1c1f8"
    sha256 cellar: :any_skip_relocation, sonoma:        "1972663b8cce7fe8a65e66cd46a1f4278ecf39167b112276245f3ed0cb1e946c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3cef75080ace9d11f415eb2a2e3d7777904b5a58cd1446ce51186aedb22e02fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f6f5fb69942765a8de1ef1ca2a3b8228887fc218e1c2665b4efc5a618dd5d1f"
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
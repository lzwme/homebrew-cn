class Arf < Formula
  desc "Modern R console with syntax highlighting and fuzzy search"
  homepage "https://github.com/eitsupi/arf"
  url "https://ghfast.top/https://github.com/eitsupi/arf/archive/refs/tags/v0.4.2.tar.gz"
  sha256 "eeaddc41d7bfc514e33ebdb9ee2b8b8aac642e4d6940c68b9d0a0bf036f09ed0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "234f4bfe688bd1ec9e1595ae88e0f50ebe7895a11f03294f2e637c474e945ff5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b2cf2e295666c4f1569e8bdbd5f6e3fbcf993b2f90c9451cd18d702086033636"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "14979ff5eb8439ac30144c3be28dd02b6bd2de2494511e571b69e0f67ea143ff"
    sha256 cellar: :any_skip_relocation, sonoma:        "be90bacdc8babc213d9a0a6c4600f42a80aed1d5ef53bfc9a6c9f118b0b853c4"
    sha256 cellar: :any,                 arm64_linux:   "0af934e239f5e7b6da156b34b74c0bb3dea51c812449de6421c184e3f366656a"
    sha256 cellar: :any,                 x86_64_linux:  "ae102c0fa683ec02e1648ae87b702715d9e7868aaa265721134da6944065af8f"
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
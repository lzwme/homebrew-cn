class Arf < Formula
  desc "Modern R console with syntax highlighting and fuzzy search"
  homepage "https://github.com/eitsupi/arf"
  url "https://ghfast.top/https://github.com/eitsupi/arf/archive/refs/tags/v0.4.5.tar.gz"
  sha256 "42f06bb7eae572bac427438e9c8bdd181f1666073e14014c61062ec6c92e3802"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "347090fd7f5a6b6843eb9198a18a58bc92b75649793071a6736e9e5f90c67fd4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9c2a468f1e6ca2b5393f9ea6790d6b73e10c4f51a67a0e1628389ca8ee9410a7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ae0f201755c34427dbdef54d8e1729b19729e1c8987bbf79593bf8c21103ab8b"
    sha256 cellar: :any_skip_relocation, sonoma:        "2d3ace1434da32b20a8db2a5d36fe07f68aa4400c48b522715a4935bc5e4aef3"
    sha256 cellar: :any,                 arm64_linux:   "3deee7bfe0f1898fba88297d8f61feb857b407350199929f6380a4037d819ca2"
    sha256 cellar: :any,                 x86_64_linux:  "f309fde814e9b2a1b1b55e9979baba788c5ba36fbdd0ad6108535ff4eaef2e81"
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
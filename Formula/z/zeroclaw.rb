class Zeroclaw < Formula
  desc "Rust-first autonomous agent runtime"
  homepage "https://github.com/zeroclaw-labs/zeroclaw"
  url "https://ghfast.top/https://github.com/zeroclaw-labs/zeroclaw/archive/refs/tags/v0.5.8.tar.gz"
  sha256 "c8690b40a5ea24a72695708ebe1c11e54e902f00840dd1945077b8ffc31540c3"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/zeroclaw-labs/zeroclaw.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "80303b3eeecd760fca7827cbf27b041e871ffa9932d81029fa1a2a0f160fc5bd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e0f743d45590f76a82ea26259f7878664cc642daddf258881250498505e2b785"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d6950e457d8c1f2d1965a7abb265a6c2677aba42585d28465847aa4fd8d347a4"
    sha256 cellar: :any_skip_relocation, sonoma:        "cd0bc4097277dc097adf8e10fefa9b0c8ad91dd3c619ed3f9e3896c6b7b7f5c4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f00f90d82b9bb3ebac759b77aba8f0cb35612295f38982062894e3136bf44780"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c26c13b31327f4911a82ff91d092ccd317c2c24e71246cda01f6f33b42d826b9"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  service do
    run [opt_bin/"zeroclaw", "daemon"]
    keep_alive true
    working_dir var/"zeroclaw"
    environment_variables ZEROCLAW_WORKSPACE: var/"zeroclaw"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zeroclaw --version")

    ENV["ZEROCLAW_WORKSPACE"] = testpath.to_s
    assert_match "ZeroClaw Status", shell_output("#{bin}/zeroclaw status")
    assert_path_exists testpath/"config.toml"
  end
end
class Zeroclaw < Formula
  desc "Rust-first autonomous agent runtime"
  homepage "https://github.com/zeroclaw-labs/zeroclaw"
  url "https://ghfast.top/https://github.com/zeroclaw-labs/zeroclaw/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "0b36685cc0725e5a95fb378d8654a34d63999f734e011436715c00a934b71f10"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/zeroclaw-labs/zeroclaw.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "61bf7a0f3901fc32651b7215f3c33b85d84ad3ef70140a3fa67d9ca1fad1a47e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1bb4521b7fad483b06b2af541098a5d7a30adf9020aee256ba61688e93e26395"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5cb57b36604cd027436e7d4f026eee8fd34d8fc748c018c557a736c7cda6a047"
    sha256 cellar: :any_skip_relocation, sonoma:        "2f2e9387e774a7c073f61bb2a9fbef9ef6c7cf38bb48b0e6395f81995e965480"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "18f58c7dcadf2a9f4ac70c1830f45eac80e920f90c1c48abba791d084031ede5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9068ab6055dcfd53aee4d816ae484c494771be5ff80efafacf71128bd6944d85"
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
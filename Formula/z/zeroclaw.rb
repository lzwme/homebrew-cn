class Zeroclaw < Formula
  desc "Rust-first autonomous agent runtime"
  homepage "https://github.com/zeroclaw-labs/zeroclaw"
  url "https://ghfast.top/https://github.com/zeroclaw-labs/zeroclaw/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "970c2fcbbc3fd0566420183df317cf0441acd0c6ca3147e55bbccbb8ab142980"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/zeroclaw-labs/zeroclaw.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "52436f03c02c7d157ee7f870690c74191a96bb0d95f091e86a3fafbea79cf472"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b6c96ff91373786f69329fb6700c1f3f37acf97becaa57079c2e48ad9229dfa4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "79d8c369353cb54abd8aa08ee1692c625749411f403c73ed37a2de8e655bd38a"
    sha256 cellar: :any_skip_relocation, sonoma:        "089dede7745a168abfc3ddb38ea8041f6b0d14950341034fcd71feaad53a0e3a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "20edf298139fa7f2a4d3e2f4ed71671b35fe0728ab35e447fb8c0545ab9c2b43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b3cccbd3d4aa7a88e340c8161a5505e8707a8487093de965e3a7d019e2465a0"
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
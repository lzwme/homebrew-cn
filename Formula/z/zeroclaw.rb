class Zeroclaw < Formula
  desc "Rust-first autonomous agent runtime"
  homepage "https://github.com/zeroclaw-labs/zeroclaw"
  url "https://ghfast.top/https://github.com/zeroclaw-labs/zeroclaw/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "18a6800803672d7e3064c1a541e53b7ab409b001490c71a5d7ea64baf2040442"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/zeroclaw-labs/zeroclaw.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e0b2fc7de4db71cb2ce795f7f036056e6d9d8e7a4685955787c0bbcb87f74153"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d5946c3b7d9ccb176afa479771291f55f2b7ca87acbb72a7beec89e05fd6d2d1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cd2d377a6cce5f29244be2f3253c93e728a5c6079ce62a527eac66bb7cc9e9d8"
    sha256 cellar: :any_skip_relocation, sonoma:        "b26e7466eb1614dcb101285fbf62f922f4c14bd84121dd3de0356f2fc1e3947d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "056547a7a3b883ad4e5e5b0e0968f0cf3949a5d71dbb3c3ea1c4e712a411bbc2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ab498c02687dee7ff9459a8201b0f7700479cabb1b3be8d48cec0019a666b29"
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
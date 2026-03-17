class Zeroclaw < Formula
  desc "Rust-first autonomous agent runtime"
  homepage "https://github.com/zeroclaw-labs/zeroclaw"
  url "https://ghfast.top/https://github.com/zeroclaw-labs/zeroclaw/archive/refs/tags/v0.4.2.tar.gz"
  sha256 "b49856ad2f153941c95562885649f312179efe55a2bdaab61e066917dc17ea83"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/zeroclaw-labs/zeroclaw.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fe1d76efb11e22629e5a2addfbd246513cd93f433f53c152f6e98f4470cd7d64"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "74cfcb84cbd32bff2a68e12fd6a3955f71f3ed100d164d48a52c8694d799a6f7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "19ecae115cee1fa29a47f98fba2a8b90ca9b6147bc9a6e8b3c00ea984a2c09a8"
    sha256 cellar: :any_skip_relocation, sonoma:        "434d97f856a9ad47c03a8387bc0f5a7fcb01caf9be6e6f148c8754d385d18bb4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7502171feae7bfd0fd11916ac86e907a990ba3934ffd8ea0b1d7fc99eb55d862"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8421239aed5743c9f7bc99a4e4f793993be7c665eaf337869034c5239fd940e4"
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
class Ducker < Formula
  desc "Slightly quackers Docker TUI based on k9s"
  homepage "https://github.com/robertpsoane/ducker"
  url "https://ghfast.top/https://github.com/robertpsoane/ducker/archive/refs/tags/v0.6.3.tar.gz"
  sha256 "263cc295df1781693cbd87fbe165f2b5ba6680a01f533d1b49346eda0b4f3c2c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9db28cc2473d24211b9b23b2084b8883edba3e2681bd31c41247723b22dacb56"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7f04ad71bdef7753fcdb1f10f00c117287b943db79ad78c6a5e2cf2ca8134267"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0e2d63155b374921f045bc5d06a6ab6293cc9d12af7b224f307964f60a0c4401"
    sha256 cellar: :any_skip_relocation, sonoma:        "54cc2d496c75fab7905f898d50cf1d1b2d0f5aaabb1ff31024ba812889d8a46f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6d08fed4d8100da2b24066e015c65b0e6b8484db18e77519066d38ffa666d65a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "58be72cfc69cbd4a656d4628a0ec11836411bf28c0fed2c08f00f4024e0cb3f6"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"ducker", "--export-default-config"
    assert_match "prompt", (testpath/".config/ducker/config.yaml").read

    assert_match "ducker #{version}", shell_output("#{bin}/ducker --version")
  end
end
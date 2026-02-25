class Zeroclaw < Formula
  desc "Rust-first autonomous agent runtime"
  homepage "https://github.com/zeroclaw-labs/zeroclaw"
  url "https://ghfast.top/https://github.com/zeroclaw-labs/zeroclaw/archive/refs/tags/v0.1.7.tar.gz"
  sha256 "8494d08a047a4d52546e7ba37dffa9aa0334f72c968357231f583dd395df2479"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/zeroclaw-labs/zeroclaw.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f69ab73376a5c5653d8082c764e856e10e46064024b106a404de8ea943aa67ad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "311e3cc04211e69c63deeaa84a145ec6f11d3f31c58b40ff84be9b88314f783a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2bbae39ac9cda10e2e48995323df63750fbe894fb8fdb225aee18870c3fc6fb3"
    sha256 cellar: :any_skip_relocation, sonoma:        "f1e087fdc7caca80ae230540be8f5e8b6aab2c8591b52d3d9fcd2b57dae8cbb1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d88f2d6ff966e3ae04b32d554be9a771df642eedb23d9a573d127aa206d5660c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f9d24453b52b2608349d8432dfd51f6519b07577e1ea09593f66213e448137ff"
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
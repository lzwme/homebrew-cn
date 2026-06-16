class Fakecloud < Formula
  desc "Free, open-source local AWS cloud emulator for integration testing"
  homepage "https://fakecloud.dev/"
  url "https://ghfast.top/https://github.com/faiscadev/fakecloud/archive/refs/tags/v0.19.1.tar.gz"
  sha256 "f02187f72063ce27153160dfb31990ec8d4af2d13866cd58fd20147a28fec79f"
  license "AGPL-3.0-or-later"
  head "https://github.com/faiscadev/fakecloud.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "76436d09f8df9899bc159319b4bc8210e9f50d68f3d82ed69431ab5da5adf9ea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5984a40d4790adfa085f538a1c9f096957ebb9caa69e2a57654d2b9c0a4b55bd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d5ec118611df38e7af67e60ade33a87117c6e6996d1e32081c68a37d5beaab6b"
    sha256 cellar: :any_skip_relocation, sonoma:        "4d00c4294595977844a506aae51a0e26f638e409dd9a0ab17b457d759f09825f"
    sha256 cellar: :any,                 arm64_linux:   "1f94b7082ba2cc4e3f7429864f42980bb31228936202f11e29bc6dd4d54140d9"
    sha256 cellar: :any,                 x86_64_linux:  "19cc01d4dc0e631fecf9a4fe9018fe0e25ab52f876f85ec906a13149df1c3146"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/fakecloud-server")
  end

  service do
    run [opt_bin/"fakecloud"]
    keep_alive true
  end

  test do
    port = free_port

    assert_match version.to_s, shell_output("#{bin}/fakecloud --version")

    pid = spawn bin/"fakecloud", "--addr", "127.0.0.1:#{port}"
    sleep 3

    output = shell_output("curl -s http://127.0.0.1:#{port}/_fakecloud/health 2>&1")
    assert_match "ok", output.downcase
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
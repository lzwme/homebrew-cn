class Fakecloud < Formula
  desc "Free, open-source local AWS cloud emulator for integration testing"
  homepage "https://fakecloud.dev/"
  url "https://ghfast.top/https://github.com/faiscadev/fakecloud/archive/refs/tags/v0.21.1.tar.gz"
  sha256 "0d8b509bba1d667d45e9526eecfea5f72f7d968f5b9f4fbf89d7c3acf153412d"
  license "AGPL-3.0-or-later"
  head "https://github.com/faiscadev/fakecloud.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d916d236ec6663eb07a2b9ec9200577b099996d02f47f6f083dd8fbf882dcb3e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7991db5dfa02b03952137671a5273ad0b9678d1e4478c230eeebf5abcf9d77aa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "07d6902d36b68a6b7e4058864796edbc1ef00b4b760952f805de8b25c28bf280"
    sha256 cellar: :any_skip_relocation, sonoma:        "bd23c85d99ef6320d9fa8e721dd194a0efb8a7ee2f9640aabf16e32bfdc24c89"
    sha256 cellar: :any,                 arm64_linux:   "b09c899bd9626353a863cd20a9d6f555fa9715c8ab4dc2f267dac4c12cbe2b5a"
    sha256 cellar: :any,                 x86_64_linux:  "93dc8ea64defb863390506867506eef01b71d9d94bdd66704e0f319784da6901"
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
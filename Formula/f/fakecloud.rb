class Fakecloud < Formula
  desc "Free, open-source local AWS cloud emulator for integration testing"
  homepage "https://fakecloud.dev/"
  url "https://ghfast.top/https://github.com/faiscadev/fakecloud/archive/refs/tags/v0.42.0.tar.gz"
  sha256 "4c779b4c24f35f4a00096aa1564cb99e8375f54cf0d9c60835f10021fd3529cf"
  license "AGPL-3.0-or-later"
  head "https://github.com/faiscadev/fakecloud.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "acf8db472d113c09d080786725650a7624e94fb92cfb9799b94a0baa8808f72b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e8c6583051634114b4d6795e021a6f9c6af4daf610cfb2f2aef0d7fa9898299a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "692247ec25ab9ce3d2a832bc75f8803c18dda4ecba3e06ce5e2789d1e1a083c8"
    sha256 cellar: :any_skip_relocation, sonoma:        "967f3fd80e59aac377b5b2806979e789a839ce0ba7f2442eaa76f411ca51d8e3"
    sha256 cellar: :any,                 arm64_linux:   "0ae8bd07f5d9cdc48825c0ddefb9ff64730ce8f34e4daf215258ddd7511c05da"
    sha256 cellar: :any,                 x86_64_linux:  "a108f0ecd65d9f4846cd5c633db6d5172b8f9123823f61a702d90028f51dcb23"
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
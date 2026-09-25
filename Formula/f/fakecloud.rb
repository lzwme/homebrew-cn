class Fakecloud < Formula
  desc "Free, open-source local AWS cloud emulator for integration testing"
  homepage "https://fakecloud.dev/"
  url "https://ghfast.top/https://github.com/faiscadev/fakecloud/archive/refs/tags/v0.46.0.tar.gz"
  sha256 "62d9052b35c6528876f653d475adf5be1cc31d02dd40a9c7dcf3a34237e71e14"
  license "AGPL-3.0-or-later"
  head "https://github.com/faiscadev/fakecloud.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f9a91b2577de585362c04c5de338894a92b360741dd0dc2f31022dd037a2f343"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5fba9bddc4ebed43a88a7a8ec3771cef2e8cbdfa66096bcf8e52364126eb8ca2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "02810a7f74a71e3301799def79d733a4725bcf91cbd459378b56225fd27a9945"
    sha256 cellar: :any,                 arm64_linux:       "b2fb9f6cb79855676b4fa0c85925e826967a17e51bbc4e362dcf5b12eb2dfd39"
    sha256 cellar: :any,                 x86_64_linux:      "f88f86b94a62a8f549680894665c37b96e307a06fdc7680b93891d25f7e63d25"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
    depends_on "zlib-ng-compat"
  end

  # Test binds and queries a local fakecloud server
  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
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
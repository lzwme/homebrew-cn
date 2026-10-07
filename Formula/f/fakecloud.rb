class Fakecloud < Formula
  desc "Free, open-source local AWS cloud emulator for integration testing"
  homepage "https://fakecloud.dev/"
  url "https://ghfast.top/https://github.com/faiscadev/fakecloud/archive/refs/tags/v0.50.0.tar.gz"
  sha256 "8bfc6c977a773f8488911458e400d1e3bb01e0719a1c320f2286e68b7a7d4759"
  license "AGPL-3.0-or-later"
  head "https://github.com/faiscadev/fakecloud.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9a85acf082bccfd112c91479ee52ea14583109bec307013ea79920216b125a29"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "49aae679dcca78368ecf7540fd01c28ac825ce9f9a6a37fb350ffaa8f7ad91ea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3da3bbb7b52ae2fd00d6ae6e93b9b683a4ca8a0a8644c805830452729d68e37e"
    sha256 cellar: :any,                 arm64_linux:       "65e8f5d13ad381f425a4452ee792108607cd48cca952d3dd79a6874e343b068c"
    sha256 cellar: :any,                 x86_64_linux:      "75904426288fba454aaadf61190e8ba7b988b7ddb7148271969a52990d51a11c"
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
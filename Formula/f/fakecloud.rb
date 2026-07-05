class Fakecloud < Formula
  desc "Free, open-source local AWS cloud emulator for integration testing"
  homepage "https://fakecloud.dev/"
  url "https://ghfast.top/https://github.com/faiscadev/fakecloud/archive/refs/tags/v0.37.0.tar.gz"
  sha256 "3d508727c780bf7d05f6ecc7fa5d7d227974167ded9db621ef522bf843c03a32"
  license "AGPL-3.0-or-later"
  head "https://github.com/faiscadev/fakecloud.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bc3cb7790f1f03faae82dbc13af71e61f1515610b0226bac330ca7f620820de6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7ece52ad2e959d5d2433e06be67693942c5d151f29a6654985db4f4acf8caff1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "99f3d223931dff11d517dda614d2eeb3cc044478827fdf0a29c86e152d8551d2"
    sha256 cellar: :any_skip_relocation, sonoma:        "9b971435339495938470d428251c75fa94a2dd5ad20ffca62d29c70967521a32"
    sha256 cellar: :any,                 arm64_linux:   "00654d89ad40e4af34b21fb839710a5f519edb2f2cc5e5b005a234a47db01a58"
    sha256 cellar: :any,                 x86_64_linux:  "3bd73d9fc2d54ff33e256ebf4d9686b4081f5e5dfd3105b5037f8b78afacde44"
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
class Fakecloud < Formula
  desc "Free, open-source local AWS cloud emulator for integration testing"
  homepage "https://fakecloud.dev/"
  url "https://ghfast.top/https://github.com/faiscadev/fakecloud/archive/refs/tags/v0.43.0.tar.gz"
  sha256 "f636502a4620c77a41b963e22cc606fa42259d5508eff965ca1212a4dbe22335"
  license "AGPL-3.0-or-later"
  head "https://github.com/faiscadev/fakecloud.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0891fd3adf38f4362e644bfa68ed9dc2e935a0760c1fe2970215f290165c9fdc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dcdf8305f8cc48c51fc5ebf6a4a205734055906863dc15c00348cbc5e65ddc9d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "85dc56df8171057ec749e192d8e4ea101ce774d133e73980f39c292dda4c8ef6"
    sha256 cellar: :any_skip_relocation, sonoma:        "f25a68bf32cfb21abee9a2d0e5303bda77fe6df5c3b7dd5cb8d86d29f47d6bbd"
    sha256 cellar: :any,                 arm64_linux:   "1b2dad1d72fea2a7625551afee36f477486e1509949893323e297ac17d40363a"
    sha256 cellar: :any,                 x86_64_linux:  "fa75184e5c034db78c88f3b2946ada9e2765cc6e116b2db01964ba4e232f24fd"
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
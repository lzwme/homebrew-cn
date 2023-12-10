class Sonic < Formula
  desc "Fast, lightweight & schema-less search backend"
  homepage "https://github.com/valeriansaliou/sonic"
  url "https://ghproxy.com/https://github.com/valeriansaliou/sonic/archive/refs/tags/v1.4.4.tar.gz"
  sha256 "a94f44703de0ce10da16533675e9f2a1dbcdf0139db8ace95f4bcfef71e08eb7"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ea8ea840b7e937b18814eb50fe258fb22a596ab285ea5e849324805813f7c3cd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "552014a458043f7df5049125979416d412d27fbed970e1dadf3cd4372e422318"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c9eb052e5a068c2222b73c41070593c1f48a8e364227a585c977174571014bd2"
    sha256 cellar: :any_skip_relocation, sonoma:         "c160b7168bb5b1c53d54ca009baccada75eff394788f60f60b6b914c40cc2925"
    sha256 cellar: :any_skip_relocation, ventura:        "fe89136dc93a795bb29924234571baa4f069ad3a78b6531dc8d0b35685d4d822"
    sha256 cellar: :any_skip_relocation, monterey:       "19ddafb4b71b0e860adaea2ce466b80507415f3421b8289731d010952b380e25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1e0f9ce8084dca6773828c3027e2f022fa7dff6903ee28691bfe337ac5043bdd"
  end

  depends_on "rust" => :build

  uses_from_macos "llvm" => :build
  uses_from_macos "netcat" => :test

  def install
    system "cargo", "install", *std_cargo_args
    inreplace "config.cfg", "./", var/"sonic/"
    etc.install "config.cfg" => "sonic.cfg"
  end

  service do
    run [opt_bin/"sonic", "-c", etc/"sonic.cfg"]
    keep_alive true
    working_dir var
    log_path var/"log/sonic.log"
    error_log_path var/"log/sonic.log"
  end

  test do
    port = free_port

    cp etc/"sonic.cfg", testpath/"config.cfg"
    inreplace "config.cfg", "[::1]:1491", "0.0.0.0:#{port}"
    inreplace "config.cfg", "#{var}/sonic", "."

    fork { exec bin/"sonic" }
    sleep 10
    system "nc", "-z", "localhost", port
  end
end
class Sonic < Formula
  desc "Fast, lightweight & schema-less search backend"
  homepage "https://github.com/valeriansaliou/sonic"
  url "https://ghproxy.com/https://github.com/valeriansaliou/sonic/archive/refs/tags/v1.4.5.tar.gz"
  sha256 "20f9add8b4c15b0d0fe37b29c32e310d14883d1f83b4a794cb5eabe14a299b2d"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "318c51ede43d03b2c11b19b6f82c033477a9998c4cc3359551a80c298b4db8c2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d4f6ba80e1ed6b5a1e44f442f4e4d545a18a565a222b39507d241848d825f470"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "33244249f1225cdd62a5e98e36fb371144e3cfb657ac80e857e3616b8fa467c6"
    sha256 cellar: :any_skip_relocation, sonoma:         "f652a2fc58791a1884a77260d507438941c24898416ceb97fc90a967a8fc4824"
    sha256 cellar: :any_skip_relocation, ventura:        "8e098ebead5a168c76680431a7c67728db8fdc727d84089b5609134fcd6c1a5f"
    sha256 cellar: :any_skip_relocation, monterey:       "928bbe6401e3d967d9f00ecb9bce745db89490c1026b27ba7dc6685676126e56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "77798ab83dac980c6e89c80290b7ef2692326069fbdf611833851c30f6e5cb39"
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
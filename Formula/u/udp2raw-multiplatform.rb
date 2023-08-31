class Udp2rawMultiplatform < Formula
  desc "Multi-platform(cross-platform) version of udp2raw-tunnel client"
  homepage "https://github.com/wangyu-/udp2raw-multiplatform"
  url "https://ghproxy.com/https://github.com/wangyu-/udp2raw-multiplatform/archive/refs/tags/20230206.0.tar.gz"
  sha256 "a4c2aece9e302a7895319efe940e5693522bafe9ae35b3f8088f091b35599e8a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "91759a9869401575af6f3a52a51aa4efff60aed38cb140d02e2f051bd34fb9ec"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a718e5fef4e3258d02331b824b55d336496163e4c7f94b3de712b8c1f0340d73"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "af40d80100acdacdfdcd44088f487c63c213c640d15b1f05314c0eda667a9e93"
    sha256 cellar: :any_skip_relocation, ventura:        "34a11617d24ae83e56d50032a8a8367a5a92618863c5c4e4f3bdb8ad0b91398f"
    sha256 cellar: :any_skip_relocation, monterey:       "bae88e034ddd85ff02e74744b474be4f01b0f263cdb59ca72dee587e47bd7eb1"
    sha256 cellar: :any_skip_relocation, big_sur:        "bcc9b02e7167c8096e98deafbbf4262c675d96faf02ec6a214d1650e8ea75cdf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "23603c4582835dcb9428c1c3e553802937568f9e7ea1bd283bf329541562ffdc"
  end

  depends_on "libnet"
  uses_from_macos "libpcap"

  def install
    ENV["OPT"] = Utils.safe_popen_read("libnet-config", "--cflags")

    if OS.linux?
      system "make", "linux"
    elsif OS.mac?
      system "make", "mac"
    end

    bin.install "udp2raw_mp"
    etc.install "example.conf" => "udp2raw_client.conf"
  end

  service do
    run [opt_bin/"udp2raw_mp", "--conf-file", etc/"udp2raw_client.conf"]
    keep_alive true
    require_root true
    log_path var/"log/udp2raw.log"
    error_log_path var/"log/udp2raw.log"
  end

  test do
    assert_match(/.+SOCK_RAW allocation failed: Operation not permitted/,
      shell_output(
        "#{bin}/udp2raw_mp -c -r 127.0.0.1:#{free_port} -l 127.0.0.1:#{free_port} --log-level 1 --disable-color", 255
      ))
  end
end
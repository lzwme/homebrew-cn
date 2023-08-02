class ImprovWifiSerialClient < Formula
  desc "Configure an IoT device WiFi connection using improv-wifi serial protocol"
  homepage "https://github.com/nicerloop/improv-wifi-serial-client"
  url "https://ghproxy.com/https://github.com/nicerloop/improv-wifi-serial-client/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "faaf18712de47e31cd77d3f3ec4048b859b89ff359193eabfc3059961d7c80a0"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "#{bin}/improv-wifi-serial-client", "--version"
  end
end
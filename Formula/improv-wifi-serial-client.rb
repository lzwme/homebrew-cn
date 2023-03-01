class ImprovWifiSerialClient < Formula
  desc "Configure an IoT device WiFi connection using improv-wifi serial protocol."
  homepage "https://github.com/nicerloop/improv-wifi-serial-client"
  url "https://ghproxy.com/https://github.com/nicerloop/improv-wifi-serial-client/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "74c488df6c11154cd56e4feabaf0e887a9c109fa39d04fb1dbaddb616353099b"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "improv-wifi-serial-client", "--version"
  end
end
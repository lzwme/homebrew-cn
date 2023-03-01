class Pinfinder < Formula
  desc "Recover iOS restrictions or screen time passcode from iTunes backup"
  homepage "https://pinfinder.net"
  url "https://ghproxy.com/https://github.com/gwatts/pinfinder/releases/download/1.7.1/pinfinder-mac-1.7.1.tar.gz"
  sha256 "1dcd2b705d48f830121fa308863536565735392349e28e66d5d2998a32d059b4"

  def install
    bin.install Dir["*"]
  end

  test do
    system pinfinder
  end
end
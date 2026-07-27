class Asimov < Formula
  desc "Automatically exclude development dependencies from Time Machine backups"
  homepage "https://github.com/AsimovMac/asimov"
  url "https://ghfast.top/https://github.com/AsimovMac/asimov/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "9fb785e94af7dd93e240ce6659fd702bb99f4c3f5d2673754334455a867745cc"
  license "MIT"
  head "https://github.com/AsimovMac/asimov.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "47fc305de665d921a6199c86262b4dc6cfb561474a08b34ac5f60179b1b84b62"
  end

  def install
    bin.install buildpath/"asimov"
  end

  # Asimov will run in the background on a daily basis
  service do
    run opt_bin/"asimov"
    run_type :interval
    interval 86400 # 24 hours = 60 * 60 * 24
  end

  test do
    assert_match "No new directories to exclude", shell_output(bin/"asimov")
  end
end
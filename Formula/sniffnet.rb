class Sniffnet < Formula
  desc "Cross-platform application to monitor your network traffic"
  homepage "https://github.com/GyulyVGC/sniffnet"
  url "https://ghproxy.com/https://github.com/GyulyVGC/sniffnet/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "4ed7375aec49c76ef4410f1adb93264f896a113c222d49bf1244985449b84ad3"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/GyulyVGC/sniffnet.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9c7f12692339053c3aa2245705ed7350da64f5c93026ff947e16d23a179b2587"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f1d218462a898178b98a7b472e3d2854eec135630b82ef250d2ab11b519d70c6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2022027d5330c030cc49544c8167e19694447f4102a695573c47d3a4519e52e1"
    sha256 cellar: :any_skip_relocation, ventura:        "9d10c028b7501c104959c2eb3e8fe1d0e2bb83288c41d7d0c3d681b41ca23ae4"
    sha256 cellar: :any_skip_relocation, monterey:       "8e4354e6cc350cc373b0a51a13b9394f1f88e89304717cab0cad4190c1e75c24"
    sha256 cellar: :any_skip_relocation, big_sur:        "5752835a8695242b5d4138932863bb17fc848a3e7b9199014f55031d597d8d1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc1e1325d39ffc3fda7f162a4e3056480d689c8356001f0d09934c9a6212dc91"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "libpcap"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "alsa-lib"
    depends_on "fontconfig"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    pid = fork do
      # sniffet is a GUI application
      exec bin/"sniffnet"
    end
    sleep 1
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
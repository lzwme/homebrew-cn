class Sniffnet < Formula
  desc "Cross-platform application to monitor your network traffic"
  homepage "https://github.com/GyulyVGC/sniffnet"
  url "https://ghproxy.com/https://github.com/GyulyVGC/sniffnet/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "0e2752afca87164171b5309f0785458f097d6a6db74dac270c6a3e393cbf6cfd"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/GyulyVGC/sniffnet.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0beeb2c4e30cc02009119cbaa50485805b74335ef76fe2e486f895ef1491391c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a59e5892e2e4ba6a4307625ca7c497a23d9bfa213f7eaf9b458ac690183e05ed"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "908d6e4b4ac80bcbe175653196463f09a90c8e4d00da74dc7df6d6ea9adeb96a"
    sha256 cellar: :any_skip_relocation, ventura:        "f4f2f31f3f84bf9b10dd077fd8e68a6154bc66771e9fa853186a3939539d3a32"
    sha256 cellar: :any_skip_relocation, monterey:       "8d0515688ecb8577fcd17ac3f932d95d1a1f1874cae6ffcf11ef9f82b611154e"
    sha256 cellar: :any_skip_relocation, big_sur:        "9c10a9818a2ffb1c862076ffe9aa08ac20fa5c453f9b27cd9851add474ae177f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "21ac4a339460d1e4b3ab6dceac0d926d001d2e8a600bce0e2ba0b7a693ba95bc"
  end

  depends_on "rust" => :build

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
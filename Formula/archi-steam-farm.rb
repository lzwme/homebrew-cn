class ArchiSteamFarm < Formula
  desc "Application for idling Steam cards from multiple accounts simultaneously"
  homepage "https://github.com/JustArchiNET/ArchiSteamFarm"
  url "https://github.com/JustArchiNET/ArchiSteamFarm.git",
      tag:      "5.4.4.3",
      revision: "089cc5beee7db0630cf058c74d0751d25d6d6490"
  license "Apache-2.0"
  head "https://github.com/JustArchiNET/ArchiSteamFarm.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3e29d8cf5264ec827fa7dfd84d696b5532d5d9e04e449373a4440c7f5900fcbb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0dfa902c6e2980cbd285e1d7e5c65e76ebe1243b3dfd3f178d10c0e95251de88"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7892b3921570c9ea8c653cdc3450c159d4bc6be981c61e6a374368b14a9696d5"
    sha256 cellar: :any_skip_relocation, ventura:        "0617f0da4e5f859328b91ce0b0a7edba5e63a21b127562cdb2bd600b325d674f"
    sha256 cellar: :any_skip_relocation, monterey:       "1adc3eea7b48c88ba100932b77ea913f3a24783eb859a47f185d07e4752528aa"
    sha256 cellar: :any_skip_relocation, big_sur:        "ecdd312490e45fb374968a140a6906855ed914b6673b1404a79f4510a577833c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2feeb0badd30dc0dfbb707c53708a5bc33603a144e6c78a937349192bcb847d6"
  end

  depends_on "dotnet"

  def install
    system "dotnet", "publish", "ArchiSteamFarm",
           "--configuration", "Release",
           "--framework", "net#{Formula["dotnet"].version.major_minor}",
           "--output", libexec

    (bin/"asf").write <<~EOS
      #!/bin/sh
      exec "#{Formula["dotnet"].opt_bin}/dotnet" "#{libexec}/ArchiSteamFarm.dll" "$@"
    EOS

    etc.install libexec/"config" => "asf"
    rm_rf libexec/"config"
    libexec.install_symlink etc/"asf" => "config"
  end

  def caveats
    <<~EOS
      ASF config files should be placed under #{etc}/asf/.
    EOS
  end

  test do
    _, stdout, wait_thr = Open3.popen2("#{bin}/asf")
    assert_match version.to_s, stdout.gets("\n")
  ensure
    Process.kill("TERM", wait_thr.pid)
  end
end
class ArchiSteamFarm < Formula
  desc "Application for idling Steam cards from multiple accounts simultaneously"
  homepage "https://github.com/JustArchiNET/ArchiSteamFarm"
  url "https://github.com/JustArchiNET/ArchiSteamFarm.git",
      tag:      "5.4.5.2",
      revision: "7721106fc728205e6a9d575f5ebeda182b162992"
  license "Apache-2.0"
  head "https://github.com/JustArchiNET/ArchiSteamFarm.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7b8c656022ce4934c039a64a181652c944d5d44d2e192c169a0aeb48454808e4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4a8308ed566762aa62462e6bce53df09a90bf2179614e0ca3dcdbdea875a2c30"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5124139e0913a43b5abcf76d78c2eacb60266f0d048417709176f35435ba94ad"
    sha256 cellar: :any_skip_relocation, ventura:        "e8d6a69b6d79e81d9fa17e3122d04d8cadae127a9186b7866f3226c01c90cf85"
    sha256 cellar: :any_skip_relocation, monterey:       "9f870aa08be904850ab8ee5a8a44561e705ea00a7af95cc584cbd5f1c7258c8b"
    sha256 cellar: :any_skip_relocation, big_sur:        "3ada382f4928bb08f2ae02daab2bf857518767e0b495f552d6a3a256890b0ef1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "afd3f98ac06363b1b563441599538fb70d712df7b28795301439f7c3068d5c3e"
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
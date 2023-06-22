class ArchiSteamFarm < Formula
  desc "Application for idling Steam cards from multiple accounts simultaneously"
  homepage "https://github.com/JustArchiNET/ArchiSteamFarm"
  url "https://github.com/JustArchiNET/ArchiSteamFarm.git",
      tag:      "5.4.7.2",
      revision: "7132340ff7e8b12fa810e1154eefe00bfbb41f4b"
  license "Apache-2.0"
  head "https://github.com/JustArchiNET/ArchiSteamFarm.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "964ebfab78341c93bb6e4249c60818e6b1b5758335dcc8df1a85b452786cda1e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cacb8f0473188a2098a2f4034324d31aa6e0d0bc2b6fd8c8f059c21880588683"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "201a63fc2965eb73a3682cdc816cc80405400f3e87d28f9a7b071efdf89f9f77"
    sha256 cellar: :any_skip_relocation, ventura:        "62cabac65ea0ecd7b14d55ae3df9fda01b6d203648040f7409e44ae6de449222"
    sha256 cellar: :any_skip_relocation, monterey:       "6c6c3197e3d6fe85de645534799ed8f18fa3479811d12fc406b4aa465b8d5085"
    sha256 cellar: :any_skip_relocation, big_sur:        "b3709024f1b7ae82709ab560b3b57413e038c6144dcbd0e9a28ad27c6482f239"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6abfd6f6c1f5354f9988a044ae7c79b293ee2a19e80c0c98d21311c9167fde3a"
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
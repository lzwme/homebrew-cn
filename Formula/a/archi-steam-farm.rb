class ArchiSteamFarm < Formula
  desc "Application for idling Steam cards from multiple accounts simultaneously"
  homepage "https://github.com/JustArchiNET/ArchiSteamFarm"
  url "https://github.com/JustArchiNET/ArchiSteamFarm.git",
      tag:      "5.4.12.5",
      revision: "7f4a11bb6a82aae5c98f62a729799e4f7d53fd9e"
  license "Apache-2.0"
  head "https://github.com/JustArchiNET/ArchiSteamFarm.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "04ad1e0347d8069b5f0617147c1bea9203923d911ff46b565b1bf6529259fdc7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "398aef08bd1c4047b684d24a34d529a1f36635c180a058c89b941310471eec6a"
    sha256 cellar: :any_skip_relocation, ventura:        "19e8c8aacddfeacc93a13e90bc0eebd3dfde43baecb6005276202527275c0e0b"
    sha256 cellar: :any_skip_relocation, monterey:       "85cb3d5cf8dcf661dfe02f9917eed1f1a79793a10de805014b39151cd5f3d4ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2ffa5bfc5adb56308de15d541a6a6eed49a0c15b0fc84ad6797611f15b03b293"
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
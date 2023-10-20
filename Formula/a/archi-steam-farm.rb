class ArchiSteamFarm < Formula
  desc "Application for idling Steam cards from multiple accounts simultaneously"
  homepage "https://github.com/JustArchiNET/ArchiSteamFarm"
  url "https://github.com/JustArchiNET/ArchiSteamFarm.git",
      tag:      "5.4.12.3",
      revision: "6a0d428fa3d905d60e7585ea15160fdd485cebbb"
  license "Apache-2.0"
  head "https://github.com/JustArchiNET/ArchiSteamFarm.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "691979aed744cbe05b92401379bd38a9e96217b46eef7a42ef4699f5b2531300"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8f64e127a4592c64c194b5097b861e08206e57b9f099455f4e56a5be95d612b2"
    sha256 cellar: :any_skip_relocation, ventura:        "9105ecfd98c2fc811d0fa78bd61b6ab732cec0fc958f9fdb73ff4ab0c47f7d42"
    sha256 cellar: :any_skip_relocation, monterey:       "12271cf3851a2f38b0b718763508208fdcf5f94cc371c535d711d88f2a905cce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "85bff8ca2fa8fe9febd5e8eae28293a000c4bbf1234c7e8906cd8861ff597c20"
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
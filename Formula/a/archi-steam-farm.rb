class ArchiSteamFarm < Formula
  desc "Application for idling Steam cards from multiple accounts simultaneously"
  homepage "https:github.comJustArchiNETArchiSteamFarm"
  url "https:github.comJustArchiNETArchiSteamFarm.git",
      tag:      "6.0.6.4",
      revision: "14388487fd4923690db5eda63624cf93d48bd609"
  license "Apache-2.0"
  head "https:github.comJustArchiNETArchiSteamFarm.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "f2d7b7424d9fdcfab15d075b3600365ffc8027c357d890f64d891d0ccee59738"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8e6110da3f551ebbe5eb63d09f3d27b4f0eabd658009098b9582686b2543c03c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2e27fc5dae3e53060a78f4d27f288f81ad8bdc4025128b1b4382bd681d2bcae9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a676aeeaa5dba715a55452c9348ff6f243806d434dbfa1669f03fa10d44ec5b4"
    sha256 cellar: :any_skip_relocation, sonoma:         "178bdfa4f233d7b5332f817bb80832695b96918c7084eb1aa8b6671bb32e09d8"
    sha256 cellar: :any_skip_relocation, ventura:        "9c0148fa2f6d60dec159165a101472de34f5d1e3a0262c1dea95971d4bed42dd"
    sha256 cellar: :any_skip_relocation, monterey:       "a05f0a12a96db489113c3ce53856ee22498b939f3ea4a673f5ebb90c20744ccb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "46bc88c66c821cdf360737208ad676e131eef5989954a83d8a74e1c944f5a943"
  end

  depends_on "dotnet"

  def install
    system "dotnet", "publish", "ArchiSteamFarm",
           "--configuration", "Release",
           "--framework", "net#{Formula["dotnet"].version.major_minor}",
           "--output", libexec

    (bin"asf").write <<~EOS
      #!binsh
      exec "#{Formula["dotnet"].opt_bin}dotnet" "#{libexec}ArchiSteamFarm.dll" "$@"
    EOS

    etc.install libexec"config" => "asf"
    rm_r(libexec"config")
    libexec.install_symlink etc"asf" => "config"
  end

  def caveats
    <<~EOS
      ASF config files should be placed under #{etc}asf.
    EOS
  end

  test do
    _, stdout, wait_thr = Open3.popen2("#{bin}asf")
    assert_match version.to_s, stdout.gets("\n")
  ensure
    Process.kill("TERM", wait_thr.pid)
  end
end
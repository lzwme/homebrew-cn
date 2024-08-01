class ArchiSteamFarm < Formula
  desc "Application for idling Steam cards from multiple accounts simultaneously"
  homepage "https:github.comJustArchiNETArchiSteamFarm"
  url "https:github.comJustArchiNETArchiSteamFarm.git",
      tag:      "6.0.4.4",
      revision: "11bab46b8bd6eaff2e5c5c92a00602db87b58c04"
  license "Apache-2.0"
  head "https:github.comJustArchiNETArchiSteamFarm.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f338b212f0a6cb57d22bb2765c0547b9ee698b3711afaa0c8d787d24800239d1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "13e4824f2b0ebf441497102650d392ba5fa9f568845aeb63fb1b81c1f39e8f76"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7972d1218d62f8909f02c9a9a3df28a91d9265b001137af3cf171383f7556a5b"
    sha256 cellar: :any_skip_relocation, sonoma:         "1ddee39c56a49c4ee4a5531afab9d85e3bb22c938318896f9888da96f90e98bb"
    sha256 cellar: :any_skip_relocation, ventura:        "5e1effffbe545a492d0b080b77af932b959dfed7ad81496177b2adbd6033bb0f"
    sha256 cellar: :any_skip_relocation, monterey:       "d233caa4fbd5594300a6d54fc36b6c3b81be6b1c23fd261f6bc1e3afa836a5ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "55fcfb049732b8563c9257d716e25a1bc7b456c99728d5d96531a396d7cd0c78"
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
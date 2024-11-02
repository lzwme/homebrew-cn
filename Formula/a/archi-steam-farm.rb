class ArchiSteamFarm < Formula
  desc "Application for idling Steam cards from multiple accounts simultaneously"
  homepage "https:github.comJustArchiNETArchiSteamFarm"
  url "https:github.comJustArchiNETArchiSteamFarm.git",
      tag:      "6.0.8.7",
      revision: "6dddaa59926c1e48419e5d374deef8aa712ad610"
  license "Apache-2.0"
  head "https:github.comJustArchiNETArchiSteamFarm.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2f24faa5b51214ab397457659b1ccc762326838b11830ff5b4a172aba55adfe4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "81f4c5700219ddd6e4985d99626ca6c0cf1d7a93dc78b0461436fecb386f7d60"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7cce50bdc9e5c9571d0ed1a44a63e632124f248528ef74f85cb7f6052ac3f1c4"
    sha256 cellar: :any_skip_relocation, sonoma:        "a85aba84e903b06ea25de654c8f3513a6c2e633f550efca7dc72dc4f0da58c86"
    sha256 cellar: :any_skip_relocation, ventura:       "2d66e00e8bade512b95191b8f1ec1f3df40f7d176b672355f8d7306b446484c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab7f434ff00838f5624ae8bbcfae725be034cf139261513b7923ab9def0aed5e"
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
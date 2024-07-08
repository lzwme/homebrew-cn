class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.288.tar.gz"
  sha256 "349451917c5f22e49255977c83113266eb9f4d138451b8d354ee18cfa60e6fc4"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d89637bfc4e64ad8a3798912a33a1b1dc71d64b41c4a90492480c35675cef0f4"
    sha256 cellar: :any,                 arm64_ventura:  "df6440b860276185029f4c552aa45ab74bad14a967bc3f26173d7e3c67d46db5"
    sha256 cellar: :any,                 arm64_monterey: "176f210db07098867abe35ccb95920c62fc7a60de655bc2f7b6ee4f5851d8e6b"
    sha256 cellar: :any,                 sonoma:         "3f83bdd6d1666ae0f5df6021aa73aca6e672bb67cafd753146931ffbecbc518e"
    sha256 cellar: :any,                 ventura:        "02d3dd442ab365d304c39332527fdeb41e2f82102bcb8a92d62ce1be30d34d65"
    sha256 cellar: :any,                 monterey:       "c4ff3348e5e378887565728375300026b97b8c142f43d82252a782a32f097d72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "62adf0b1d9a4c4ef2e1a1a706bfb868b08443822c817ddefdd03e5def871e4a1"
  end

  depends_on "dotnet"

  def install
    dotnet = Formula["dotnet"]
    os = OS.mac? ? "osx" : OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s

    args = %W[
      --configuration Release
      --framework net#{dotnet.version.major_minor}
      --output #{libexec}
      --runtime #{os}-#{arch}
      --no-self-contained
    ]
    if build.stable?
      args += %W[
        p:AssemblyVersion=#{version}
        p:FileVersion=#{version}
        p:InformationalVersion=#{version}
        p:Version=#{version}
      ]
    end

    system "dotnet", "publish", "srcJackett.Server", *args

    (bin"jackett").write_env_script libexec"jackett", "--NoUpdates",
      DOTNET_ROOT: "${DOTNET_ROOT:-#{dotnet.opt_libexec}}"
  end

  service do
    run opt_bin"jackett"
    keep_alive true
    working_dir opt_libexec
    log_path var"logjackett.log"
    error_log_path var"logjackett.log"
  end

  test do
    assert_match(^Jackett v#{Regexp.escape(version)}$, shell_output("#{bin}jackett --version 2>&1; true"))

    port = free_port

    pid = fork do
      exec "#{bin}jackett", "-d", testpath, "-p", port.to_s
    end

    begin
      sleep 15
      assert_match "<title>Jackett<title>", shell_output("curl -b cookiefile -c cookiefile -L --silent http:localhost:#{port}")
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end
class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.21.2441.tar.gz"
  sha256 "db048dd645c8577bda32fc2d82b9c1434da3ffc12d3d76b9bb6b477e56776b54"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c845fdfcea5b548e0952e0f067f09086ed794d5fb58f0fd45d3645b279bc1e62"
    sha256 cellar: :any,                 arm64_monterey: "ea3be9047d820da07360f19eff6983937346f0062f42268c84af5bd9f011bf86"
    sha256 cellar: :any,                 ventura:        "982a4267a47cc71b3dfea2dfe523573a96e668d8013e66d0153cc9a56c0199af"
    sha256 cellar: :any,                 monterey:       "5b909f678fdfe5fe292a618f8db4371ce157fcb6127ef7b0618c4f14200117ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ba8d3a787c3bb28ac454000f2e0b6a5e54d895174c2be2b53f2762f27f968cd"
  end

  depends_on "dotnet@6"

  def install
    dotnet = Formula["dotnet@6"]
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
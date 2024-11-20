class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.968.tar.gz"
  sha256 "7b22d1f38181c45df06c7a8eb9a9661c383ba2053c6c41c44774a228e732bcc5"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "55b14c425be68e2c6ef5af993bd8a1717f5296a4c6043170f66bfd8b7a475fdc"
    sha256 cellar: :any,                 arm64_sonoma:  "daefe045a8cd65643a3ffa6faccda02ac59802f5c5b3b1a6bb3c9177c44d4036"
    sha256 cellar: :any,                 arm64_ventura: "d28ea12ffb92b3da48b5ac3d3684826ba0590ee2a07dac50d74ae826ae7af016"
    sha256 cellar: :any,                 ventura:       "42959de600fdb0f548077435fac6f0d6cffda89732f9d39eb54354321da9db1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7f04645c2e96ad87353b6bcd04f45124d6500936e5e3f6ca11954d4cc4d800fc"
  end

  depends_on "dotnet@8"

  def install
    dotnet = Formula["dotnet@8"]
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
      exec bin"jackett", "-d", testpath, "-p", port.to_s
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
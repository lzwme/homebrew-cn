class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1865.tar.gz"
  sha256 "d75094fbe3febdcce4c06b37163feb4b2c8a27212f5ae583fce6e32e3c87643f"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "675adcadbddfb0e44a1fd7d89abc1e3746d37b24c58b760d5041303e86748839"
    sha256 cellar: :any,                 arm64_sonoma:  "3528f2c5fc2297b2889e4fcbb7aef5ab4642b26dc3702373e732f24f99cdcf44"
    sha256 cellar: :any,                 arm64_ventura: "d0e06444642c3112183e54e59715cd0c80d4419debfe2441aef903fa31556049"
    sha256 cellar: :any,                 ventura:       "d8fb79435de62f77ec266b0b24813b4507d356ecf84138e33469a5cc158e0e22"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fe7a720c3a2a9bbf2121d12c14f12c8b6a53c2c9700e39b924b0dbe2b9ff31f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c96ebf1fb7fdb1d982b8fad477877781161cef9bb39f6e881659a7adaec8bda"
  end

  depends_on "dotnet@8"

  def install
    ENV["DOTNET_CLI_TELEMETRY_OPTOUT"] = "1"
    ENV["DOTNET_SYSTEM_GLOBALIZATION_INVARIANT"] = "1"

    dotnet = Formula["dotnet@8"]

    args = %W[
      --configuration Release
      --framework net#{dotnet.version.major_minor}
      --output #{libexec}
      --no-self-contained
      --use-current-runtime
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
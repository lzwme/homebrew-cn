class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.134.tar.gz"
  sha256 "6f9d99db23788b3a97aa7bc000d92fae96805ba2c8e1b8ac178ab9d507760c68"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "21ba5fa5b77e8ddf90a745a69069899d2d8293c82807f23ea63a19db16717c33"
    sha256 cellar: :any,                 arm64_sequoia: "8992e516b1838806bd4a8f30b28e4111902c8e486bf2b8229c259e8fabd82080"
    sha256 cellar: :any,                 arm64_sonoma:  "59559865d0147ff8a2dd0ed40c234099995041ad0193fda04dbfede8bf157bb8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f90a4fbb61e4f22c9d1aa6ab31f626f794384a55e3bca1889ef6dab74a95d6bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "71aa589f5aabc1ce74f58dac50cd38998337485b0bd911e2a6d16de40ce267fc"
  end

  depends_on "dotnet"

  def install
    ENV["DOTNET_CLI_TELEMETRY_OPTOUT"] = "1"
    ENV["DOTNET_SYSTEM_GLOBALIZATION_INVARIANT"] = "1"

    dotnet = Formula["dotnet"]

    args = %W[
      --configuration Release
      --framework net#{dotnet.version.major_minor}
      --output #{libexec}
      --no-self-contained
      --use-current-runtime
    ]
    if build.stable?
      args += %W[
        /p:AssemblyVersion=#{version}
        /p:FileVersion=#{version}
        /p:InformationalVersion=#{version}
        /p:Version=#{version}
      ]
    end

    system "dotnet", "publish", "src/Jackett.Server", *args

    (bin/"jackett").write_env_script libexec/"jackett", "--NoUpdates",
      DOTNET_ROOT: "${DOTNET_ROOT:-#{dotnet.opt_libexec}}"
  end

  service do
    run opt_bin/"jackett"
    keep_alive true
    working_dir opt_libexec
    log_path var/"log/jackett.log"
    error_log_path var/"log/jackett.log"
  end

  test do
    assert_match(/^Jackett v#{Regexp.escape(version)}$/, shell_output("#{bin}/jackett --version 2>&1; true"))

    port = free_port

    pid = fork do
      exec bin/"jackett", "-d", testpath, "-p", port.to_s
    end

    begin
      sleep 15
      assert_match "<title>Jackett</title>", shell_output("curl -b cookiefile -c cookiefile -L --silent http://localhost:#{port}")
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end
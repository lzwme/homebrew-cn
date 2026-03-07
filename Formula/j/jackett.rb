class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.1292.tar.gz"
  sha256 "b19d14b406fa48ba7a465234ca81e11b5ac7c0f68dc875f37483969ae3c3423d"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "006253f8dea0b00384ee2fe8813d339b70e1403e7c270fc08d193f8ba43dc4e1"
    sha256 cellar: :any,                 arm64_sequoia: "a8412dc1a4efb948f11e651634be93865b4bf68113edc36db1cc4a8b00160a46"
    sha256 cellar: :any,                 arm64_sonoma:  "b181c07731fca3f7ac05ecab7e47470c081d8ac8c38ab75aab1eef1cf2b9cd60"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a6b378100f06ea6ab5b2192c4bfc6c371c19df55bf69efcc138a06e118553499"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1f57328e8b2f646f573b9058fbb3c5bbaf3d651417df366c1592b501fdda43cf"
  end

  depends_on "dotnet@9"

  def install
    ENV["DOTNET_CLI_TELEMETRY_OPTOUT"] = "1"
    ENV["DOTNET_SYSTEM_GLOBALIZATION_INVARIANT"] = "1"

    dotnet = Formula["dotnet@9"]

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

    pid = spawn bin/"jackett", "-d", testpath, "-p", port.to_s

    begin
      sleep 15
      assert_match "<title>Jackett</title>", shell_output("curl -b cookiefile -c cookiefile -L --silent http://localhost:#{port}")
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end
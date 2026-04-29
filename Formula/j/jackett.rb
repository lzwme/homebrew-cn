class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.1789.tar.gz"
  sha256 "e8fe1617795b23d9d690e92e116d59c3263c805a1300ad25c0316fde4844422e"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0f79647ca11c2b01bad3e630dd3290a1aec71f2bc34d56d7c3241de1a4dee435"
    sha256 cellar: :any,                 arm64_sequoia: "e6dce550fb1610eb8df1ceff992458289b2795ec335bfc5e752383b0b6fca488"
    sha256 cellar: :any,                 arm64_sonoma:  "043ee253c85cda43f6812f5952193b29dd1700f91b9d5463762c5c7748c3e495"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7aafd1c7fc543c663c2750971bbcb543c25edd3ddb2f999a8eb0e6052323ef49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "19fa58b3b9a20eb3cf7625fe4e0fd9c22d7fa11d8194112ceae010f3b0f8eb6b"
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
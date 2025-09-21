class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.23.45.tar.gz"
  sha256 "0592eeadfb9c399a2788ace5b4e132e87de1c9739e43f3dac8995e48086b42dd"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "489a61f73863cb225bde251c2d3dc72830a71a78e95883abb5071454c8e3f8b5"
    sha256 cellar: :any,                 arm64_sequoia: "f61843a632f6bbe5a8b8bcab1ef41d924a525a64fd0789f2739dba5e1aa506a7"
    sha256 cellar: :any,                 arm64_sonoma:  "3517b07884a3309353262b690085e0d1e989aebd99af23bd584ffe7fdf054b6b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9621d494b86c1bb1c62d8f3372496f07de3b98748cc155728b481c60c0618181"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "492035f5883e55694bfd1e42f7154f8277d246cda851e51e02fbd825ba58f423"
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
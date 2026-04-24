class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.1731.tar.gz"
  sha256 "b3e41c593e16da2839f0c64488912b8eb3b603cd6cceba8356e0b8f0dae545f9"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9ea1ce018450289f9ab811bd224607544b3b854f742a5081d2e0c92568675abe"
    sha256 cellar: :any,                 arm64_sequoia: "0fe7e69d62694a4737cab38d36eff58b6e679099c6d467cb2817bdf84e5b5e6c"
    sha256 cellar: :any,                 arm64_sonoma:  "e65baef0060bfef49e612e4b0922a74f982dbea7e547b9da87d544832698e1b0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e9b965e4a054cbdfac35e1b0e48f0bbea3b1e51c01d60d7092dbbdba8f72af77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "355b5cff8624b5b1426c8f63441dac916f177f19b232cdb8c86e116e83c2bd41"
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
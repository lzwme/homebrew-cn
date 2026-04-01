class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.1502.tar.gz"
  sha256 "788359ef971776d0f022e8c0a570ab4b0fc14387a3b71404b002846bfc1f6bae"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2b244a0e5a77fa7b050ae6a560ed181b03893f5b9bc747f1e65b9adcec6e1041"
    sha256 cellar: :any,                 arm64_sequoia: "143f7c12db926f5668078cfe209f63860b2dbbc3b4bb97697eaa344c0b82a187"
    sha256 cellar: :any,                 arm64_sonoma:  "e9c539eb2ebafb7707210a275fd539c5ea2677f917aa0027ac560af13ed73ad1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eb9791404fd2a27c16cbcb6788d8d5c25a69fe0d7097916d3972ca877dc06fb2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7814fc0af24a2b67ae0b037e7c87f0338fc55c31a04b33638baa4f837a94f147"
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
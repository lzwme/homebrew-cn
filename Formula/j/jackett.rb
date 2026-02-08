class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.1060.tar.gz"
  sha256 "c1c5b6e11c676d88bf57edd5763cad9c7b166e907e2b29292f4c01df63f8cc78"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "61f07b958c7b1c397401b363fc08f4dd716f0497343915de7b8fc155e9b2af3d"
    sha256 cellar: :any,                 arm64_sequoia: "4e3dc0e19bda9ffec646bbf53333254f66ad01398e6e2be4cc1094804efd976b"
    sha256 cellar: :any,                 arm64_sonoma:  "779f96d3574504e9e50a24e27ceb9a813144029f055eb66b1eac018b90168b85"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b4c188dcd94454f7ddcf9148a705630105ecbb35e161478def335ac260071ac5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2a98f92eb23f58368f6cee038a256b056420d81130865173422b54fba89b95a9"
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
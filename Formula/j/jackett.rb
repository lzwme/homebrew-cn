class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.1012.tar.gz"
  sha256 "d1044f1364fe3c8b82a93043b33c0e746b6e460cb0b8af0ec0f190fceaec68e4"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7cb8549bd568a9709966ddaf5f3795dcbfa8d0dd4caae84fa65b7b6b7efc1bf8"
    sha256 cellar: :any,                 arm64_sequoia: "9b6dc61879d1cf014232cdbdf3e5e7b4ca3fdf82710de1297fe08dcbfcb9e40a"
    sha256 cellar: :any,                 arm64_sonoma:  "994cff2089f3d77706ed3740f9e351a5f7dc100cee017f1e9cbc704af3ec6d90"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9c2dff2c22a49b0ef40d4322b22fa3c99bda59b9a78158e00fd9db65ecc8db3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "02a767fdde018ef1de451d6981d14231e4f465ac2682b7166c02a43b54239a57"
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
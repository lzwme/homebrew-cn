class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.1032.tar.gz"
  sha256 "1f6b0d79d4997f12cddb930be0c83b018857660709a2f243a4718cb36ca7e89a"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d5efb4d7bc3e128c84b871e6e2d6d0a6dbe29f74d463815554a5262d6d0f2ed1"
    sha256 cellar: :any,                 arm64_sequoia: "8be0a4260869452e047d1ea81da8765822d85d29293b698d867425ed196b2165"
    sha256 cellar: :any,                 arm64_sonoma:  "b60fbc0575eb824f79e716084ef10c7129bdd36040a4beb7486b12c3da8297f1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f03fe46be2a47bb97b729ad7accf176dea51eee9ccefadd8e5c0021ec93e4926"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3f9dff90549d1f59e319a1d51e12e92886d3cbc0785675fafd3db88d1cc1221a"
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
class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.23.8.tar.gz"
  sha256 "b2b7c13e0522e152f355161b682a88c679438d7e9bb9ac3f02aef24c568d6223"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "dc8c1a33af5f076de8e57962bea6fd6d1b3651f26ccbc5644dfac619d0d40322"
    sha256 cellar: :any,                 arm64_sonoma:  "bbfa5c0c4dc81b73164642989f24a64caf65a646327513501c93643426d200bf"
    sha256 cellar: :any,                 arm64_ventura: "bd99b1c407db8062997a2c7162f45cdc8d88542ccd062cfec20d53d3c0957acd"
    sha256 cellar: :any,                 ventura:       "d30fd7edefcfaa2c0a0502905f2ea6876a3d4a2220240ce868834859ed2c6621"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e62e01426cc8b5fde9e265c4dfdae6339c460147fb6964770b3781c15f8819cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c916769f5ca893c4d0f7198e1ea7f7107df25d5b2d541bd5c50bbc2c8c8ad87"
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
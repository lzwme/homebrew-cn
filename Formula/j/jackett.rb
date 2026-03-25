class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.1450.tar.gz"
  sha256 "af2524e6cf15f5928e02378d9a7f3555be14f8aa156aa7e97e277b1dc813c57c"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b1e9ee23825d9e149a11b9959b05f94900e43f1573c6fc9b71933f790344298e"
    sha256 cellar: :any,                 arm64_sequoia: "b2902d2cae0dedd95e4f42aa4d368f7ea2188ab991c9e951e823955c175f2ec9"
    sha256 cellar: :any,                 arm64_sonoma:  "2b8e28589ef8321a8659ee135b0945a47e8f543185d9c46a74b3e051644c2843"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8842754e83cbceee6507d1b55234b98babed9aea360ffbe9c6ddbbbbba95cc94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4438405c974b1353f15bd35acf1efa65c36197ff3b71a619f863de79ec06d473"
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
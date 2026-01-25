class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.912.tar.gz"
  sha256 "04718808e4bfb1ba59f9537635df0fc0e2d7b6fbcb1591b90f2fcc7db1d35310"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "47bd1a102ec63cfe8e133525bd0b795843f1caac4677e15134a1b14041abd338"
    sha256 cellar: :any,                 arm64_sequoia: "edd240bdcb820a0ee1a30937a4b334f798721778332ae4ec6038cdf147721265"
    sha256 cellar: :any,                 arm64_sonoma:  "680b1e8dceebbcd07ebbda89a891ad6487f35a6c1d0648a91bebc8729a355f7d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b46a2957f9c6955d14f1448d00cb6b191bbbfad6749ed150c373f84ef2a39afe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "96589b0ba2640cfcf97ccb6f5b7cb7bc4eee79d8fd1d28069d920076f79740b8"
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
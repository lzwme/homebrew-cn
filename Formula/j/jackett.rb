class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.1234.tar.gz"
  sha256 "108aeab8dd10c65daad76e62f85727a0c6b7ed2bba76aa816d9b28899e794fd1"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4598ca23251c8ce8bb67dde1f9fce984a0f7b5f444c0c8eadf3f3b495025778a"
    sha256 cellar: :any,                 arm64_sequoia: "a8f0fe1bfaadec9b2b93497d84875de627a961f269c1f26bc697fa710d1e669b"
    sha256 cellar: :any,                 arm64_sonoma:  "ebe4280b6813054dee037facd063e6c1d22fc2b67ecd72fef0cafc1ecd183918"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e5b38bda63e806d83f54d3a9200a76c9caa8a09328243bbb24a59c01e46c3fa6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "50a068d101b8a18253de99ce8e35184993c02e74533e8547a09751318aa53cf4"
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
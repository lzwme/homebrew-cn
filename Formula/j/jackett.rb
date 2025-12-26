class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.532.tar.gz"
  sha256 "189cabcbf1e0f052401f57c5d788e79c23567015a1134cf066cca2924ab3e14b"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2a00a4bd59b254ef7b0aaa86f1a4adc3c5e6399a2ae028057d3b713d7032cdff"
    sha256 cellar: :any,                 arm64_sequoia: "59518e3fe0570ed253ef857464d9eefc6c44aa3dcec8e16cfecaeb6b6c5fa21a"
    sha256 cellar: :any,                 arm64_sonoma:  "201b57d78e2d1a393ae25d976d8482ded6acef1d1bce404f60c7a75cce71b395"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "442f98a91324b5ed678ee79cdacd4f23710f24fc12e329793ebc858053af3a04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7206407e8581f16349d8dc2ef68ee55685f0ef55f3664140d831d176cef4cf9a"
  end

  depends_on "dotnet"

  def install
    ENV["DOTNET_CLI_TELEMETRY_OPTOUT"] = "1"
    ENV["DOTNET_SYSTEM_GLOBALIZATION_INVARIANT"] = "1"

    dotnet = Formula["dotnet"]

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
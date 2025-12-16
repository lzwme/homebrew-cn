class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.454.tar.gz"
  sha256 "b691217e61f992b244e39f2b3834b7e783a80737a49d5117e987af52bb9a9872"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "fd07ed5c007589873f3836975426c4cc1f34b33cc012a829d2bc28fcf7493c14"
    sha256 cellar: :any,                 arm64_sequoia: "6163866a274b6d478678f41b4f69c157cce2aa00d87dead188a0984e22523a3b"
    sha256 cellar: :any,                 arm64_sonoma:  "e1111fa641d13549238b99ccb4cdf9374b2ca36d30b3857ff58650daeb61414e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e28012dda8267d9daffb586905f2be589edf79046ed472cf342edca7ef99b2fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b17d809a1ceda82e027bba475211a49dd2623acdf62f22dc6a3b5ab0e02b3fc3"
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
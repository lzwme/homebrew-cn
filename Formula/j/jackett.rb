class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.22.2367.tar.gz"
  sha256 "f978387da69722790811ddb6dafe561bd92f622decd740326c688f740268ea0c"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "70f1d2fea14aaeb33c9b4a42c98434fcd10ab13f2bd3ce7dc82253f35fcba6e4"
    sha256 cellar: :any,                 arm64_sonoma:  "6ba652b9551d26e58d9284a1f2bec3c5adc55c37f642c117c6db74f2b6bf883b"
    sha256 cellar: :any,                 arm64_ventura: "f4e5bd84e3987106b3cf3a5ad20a0db4fd5e74a4bd8c3ae520d3c05901dc3965"
    sha256 cellar: :any,                 ventura:       "fe6f6e549bbe1ffcf7bff66793f08c8a65464b6a203b9ec38598ff88eb75b020"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e34f6d9f609eec7ae0f80bed548ae2773805fd0476cbbe33d20f6e33d3cb970c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f4f4eea53e5a6b896a9f9e2445aba99e08045b2e42c37dda981da291be505f15"
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
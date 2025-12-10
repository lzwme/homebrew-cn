class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.425.tar.gz"
  sha256 "127b72f4406512ca0a07c06cfe91f7b91760d362318952b66d37bf52613090f4"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ae9e7f92837404b107929e8c494d638b184fdfaba2da8afd0741d7661b6433f0"
    sha256 cellar: :any,                 arm64_sequoia: "28e74a23efa2d2296b48c669e8e3fadf716cc4537ca56a120205407b613d3eb5"
    sha256 cellar: :any,                 arm64_sonoma:  "395bd55cfeb477ac016876f212e56150a1bf24af545070ce6b10a59fc622f304"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c06baa75e7a47b9e89c5e97adbedb8005ce83a6d2e4eca5239fd83e6a93629c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "624634942a43ebe20777abccab3a18c5955a57f69c43e53d3371418230ae619d"
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
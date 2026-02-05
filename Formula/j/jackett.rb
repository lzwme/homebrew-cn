class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.1027.tar.gz"
  sha256 "7a6edb0bc36dc3863775fe8e7aed7054349a9a646b79e676986c8b07035f3aa6"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "896e220765ea934d84c1503e24333927b2a2f767a5f0e88075392ae442752f97"
    sha256 cellar: :any,                 arm64_sequoia: "ed93cc38fe3ce6469acabfe98d798853f1dff4a1307e2e1781d1889b287d2199"
    sha256 cellar: :any,                 arm64_sonoma:  "34d01fc34fe9f58f9de8080ddf48d6be6d6fbede152d09c6f136f6b3a431e159"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cc71cd5b06c186329850eafda9b2d9e8fa3eac27877546eb55c8c6b5bbe87983"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "61b26bd505f73795795a3f339241ab90965fd9425a9c994cd4aca9fff72d27e4"
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
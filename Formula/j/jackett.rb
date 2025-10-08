class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.87.tar.gz"
  sha256 "bf2af35a4fa4ca3e4ecfc439cf2f19651e394feca2febc02a4ad6c0d9d74dd5f"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c77bd1cc2436eba5230ab3dd89e84694d342bca4c170e9c8084b2c243e392646"
    sha256 cellar: :any,                 arm64_sequoia: "b03f885ac4138af51d937f65a3f9917307f0357b24510339892da4650d39d420"
    sha256 cellar: :any,                 arm64_sonoma:  "f1e69db1ce377b9558edd19bca1fc2717101613522c333fdef5bab7b344b5698"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8e3a75f137334f5d6c0c5efae176c5b6fea6f31b105f6f9cfe5ee239e896a030"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7c85488857486112b0541cc6ffa9aa99ffa65cd864e8000c3fe46ca5bbfd6478"
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
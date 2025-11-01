class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.234.tar.gz"
  sha256 "72f5dd9d8054e241285e7e94c6dde40bc5987b79870f0a5484e84bdaf0931aee"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2ee7b45defd696500997c53469cfa41f529c722a7674b9d2787bba8982b274c7"
    sha256 cellar: :any,                 arm64_sequoia: "035662f0156097fb15eef9ab5fda3c35821474815e0a4b5aed1c6d85d84d31c8"
    sha256 cellar: :any,                 arm64_sonoma:  "3a8d45bff4620a4f2c6dabc713c60f089c66d18363b94520ecb5f78d5cf9ed46"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dfe548d12981ba8fca081adebd2af61fc649e8e6374427b8c3a50e8587c1d1c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "22d8c2753254f7363092b687de7ff1359cb76e52ea0bc6b17f14a4a991d145b1"
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
class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.612.tar.gz"
  sha256 "d7c3b7aaf7e9c916b9556b44f0aa3f612538f03d487363bc77b74c7b97befd22"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3101f96a1c87200d0f5d99cc764def4e999cf1cc55840a58b03bea88c1182f6f"
    sha256 cellar: :any,                 arm64_sequoia: "75bd0ce5415c02e98c3c1ab2c4feea0ec4a34a9caf871e874690a33d0444c5cc"
    sha256 cellar: :any,                 arm64_sonoma:  "b5778e334c467a75ea0aa63aa7370216d2369f92803ddfcfc23e39528eb325c6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4dfb4bd7d0623cb1653e2151a5dd11a4ec6a0a72d3b420c2a42c88e336654449"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c2db0d1e797edf33696f8a173b96ab1945ecc9f08e9ab668499a9a81a6c3a91"
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
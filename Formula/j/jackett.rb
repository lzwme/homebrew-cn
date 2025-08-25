class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.22.2329.tar.gz"
  sha256 "a0cf05391fca036461e00e07eb2330171efdf4b86967ed001d930c7d62492cad"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8b41fa8d3b2c5df34c15a9a7b44089df5351e977441fc43f61f0c6c5289cad07"
    sha256 cellar: :any,                 arm64_sonoma:  "8335c8222bd0949e47e39f107a3f39393bc7375bc61ffa3573ade4275a9f2125"
    sha256 cellar: :any,                 arm64_ventura: "a7148f36e05fa10cab09dac02c293f3e3352468f8b4e6f851ff7f8ec619ed7d0"
    sha256 cellar: :any,                 ventura:       "7b1f0ef2921da7d231e4e2fc928fec03e8e72637f956314cd57a5666f4589782"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "73ff91ba50982523e0a076a04c57ae12559034de99fb5fe56ec7a02eb29b5b89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "30f3339d0539a1468fe02fe84d236909362e9f41c4c91c36aeff0903b6701c33"
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
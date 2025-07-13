class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.22.2151.tar.gz"
  sha256 "5145c3dcecd4769a8f257745c271b443083fdeaeec39e6a97cd45c3865809436"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4abdfecf9aa0af09eb1cd530ae2a0fb284cdc3eec05e0e44a58cbbb1c58bc841"
    sha256 cellar: :any,                 arm64_sonoma:  "24a330c6dd678da4d4fe061c80ac5e5ffaee1bf553f1d6de9c5478b575d04691"
    sha256 cellar: :any,                 arm64_ventura: "87bb250a67eb9b8c61c983baf3c94dec0c947743d889520bd24ca84ada2c5285"
    sha256 cellar: :any,                 ventura:       "b2821ba0911f4a05542ddc77379a887e617f5f7c429cd927765a61e0e2793688"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eb93289d24fe00cec30b5a31f57cee2733647f7aebba9ade0a73b3c8edad6528"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "485dea554c8cc420461298ec8a59f119f3ae360c38e4a47281fb1cbcff7721fb"
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
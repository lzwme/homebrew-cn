class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.22.2390.tar.gz"
  sha256 "4780d1743d6b571243fcee995d0fe72dd2632d1d9b19b0a8550f255989905ba1"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "237107ffa1fc717fbb0b03fda15d7c151d4aa3602db75a619f8f58c6ca999f68"
    sha256 cellar: :any,                 arm64_sonoma:  "33dece701ae9feaa503f4a04104eebffb4d79a816f5d935f7725ab8206ea7e86"
    sha256 cellar: :any,                 arm64_ventura: "faccd9efaf3a96ff330d98d1e9ac3191d0544af96859977cc910e30cebc85efb"
    sha256 cellar: :any,                 ventura:       "581149bb3d22a4e31d9d768a0033eac11c37bf40429a1969a20fed2c026e93fd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e89b901ba29d499226eda7ab644be67b7c887e00d8168a67d89c381cf3b4417b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b125049f2e892818e095f3dbcead8c9cd6929fcab120815e0cd44d7afbc45537"
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
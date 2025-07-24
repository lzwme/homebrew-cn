class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.22.2185.tar.gz"
  sha256 "f691d630c9d323cbb9fde53afe371f9d8eaf1b2546a7ea6631a4841c2b230f7f"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "aeb430d7c7ed70c0515be202de938847d5bc180f9a49a5670e42074a8c1470d9"
    sha256 cellar: :any,                 arm64_sonoma:  "f24f3c7021484176cc1aafc265f96a2b2797be9b4404b184af55befda3bc2d9e"
    sha256 cellar: :any,                 arm64_ventura: "32a647344cf64918bf645e44b29af69421d2e0f2d52f969732450543eb9f3b1f"
    sha256 cellar: :any,                 ventura:       "f9d1a2c37ff11a0dcbb660d22ef5cab5be38c69a7d72c0a8340cf5dbed4f3be2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "72f185c6134bbca7c64a7db07285d37a620dea8d18c1f89993a71e9e1d0d29c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "859953791c2e595f94adfb38e2e67a4cee3b7c1af03a06aae688fc9e82da48c6"
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
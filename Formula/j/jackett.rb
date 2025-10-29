class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.200.tar.gz"
  sha256 "1672ab5aeecb31f542959540852669b63fc6c64aaea5eddfba70ce3512d02af6"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0fdf14c92894fc2bbc6635d2d9acb1d8feccdf573ff68c3ba51def6f0190be7e"
    sha256 cellar: :any,                 arm64_sequoia: "13b28abcfbce2bb429634440944932c34d6e98cb8a78c72ce9942e52ed3bbdbd"
    sha256 cellar: :any,                 arm64_sonoma:  "94fb463910482ef0922a057b712af643632cf13d916efe557d46bade4a3fedce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3e26d4e73de47926b2a6a090ffa68814fb018995b2f80f84a8dee21d1c464bcc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4abdbca5f73ca9135a187ac0ba76eb2edc1588a1b784ea86d98a18de8eeef37d"
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
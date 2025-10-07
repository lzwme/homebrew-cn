class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.82.tar.gz"
  sha256 "56c849f9ce1c04bc92beba8d8df0cacccd21e41649054c4b6f3c215930f3b6ed"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "921cc4b8db22086c248424dd91a4bb50ac22fe4d39b735c5a1806f863ac43f75"
    sha256 cellar: :any,                 arm64_sequoia: "bec7856bbefd570c2c074244987165da00c8cf079557926ac9328614e4690ca9"
    sha256 cellar: :any,                 arm64_sonoma:  "095242f4d73c6360f3f137c5edbb50b0480326a0b78b8a3f6ea0ce60c3783ffc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "81d9fe7ee23c23b3ffed52a99da3d379f6594713f274b8bd0c088635d0dc0faf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46dc6158b81c1a56f7c9ef38866736f6377748793052f3e832cc62d3aa1570b5"
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
class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.23.20.tar.gz"
  sha256 "231bd266d7f90c4aa4e908570d56e6beb648b584887317acfd9ebfee50fe473b"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4ec06c440ef5e99cc86c8e5e42b761e33f97044c614df59a94f56b395cffc9cb"
    sha256 cellar: :any,                 arm64_sequoia: "a105c79fdece879b7f123ee08ffe7f91ced62fe1f221efff79250b82b5c0a2e2"
    sha256 cellar: :any,                 arm64_sonoma:  "7a98c40f574017486437f08bdf1a5fc4588de16801412271c4887e952196bd9b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c831f220d24f2717b6ca7febc16bd1356632c1d6439d06461c11c69cf7abd4f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "84c4534c78ff81a13b89d2b7332f0571030804778b6258ce44faf82f2ab27074"
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
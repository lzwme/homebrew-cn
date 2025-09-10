class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.22.2444.tar.gz"
  sha256 "24c59b6119041af80d257f0126b17c10ccd430f1a55d818c06f8feae09b4c5d4"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "41ecc193c0fd33bd626ff30b6181d26528d639de830e0da454606d6f3be00136"
    sha256 cellar: :any,                 arm64_sonoma:  "aea1dde5b1ec66335c069297e4474161f457aaf2b080f7adb7dc5768e1d0db3f"
    sha256 cellar: :any,                 arm64_ventura: "14c5106b3d098e9dbdcce29dd16ad088f3bd0432f9450cff85ab740483f62dc5"
    sha256 cellar: :any,                 ventura:       "6d66aadc9e85c5960c1418c8b55321c0689b38032153e7198a7f1c9879a6b4e0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bd92f423b9ee5f54bc73eba792201ded42975c5e7b9104f478c653583f229247"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "49f94e7211b1f9b1142519de7487a8cec6a4dafac5d9135db8932aa364661a31"
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
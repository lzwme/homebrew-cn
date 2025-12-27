class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.545.tar.gz"
  sha256 "159884775fb6f4067e8ce624ff316fea9ab32a8943496ee311be934e39c89318"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "37cfdef82c60f00162b82f0c61eb92fdd43324bea2ec2eeda450a2fd1f7fea08"
    sha256 cellar: :any,                 arm64_sequoia: "95ec7a1af5572fe639fcbe4b04da640658eca039b886705fa1a509906cf05a82"
    sha256 cellar: :any,                 arm64_sonoma:  "9ff737441070e071e5aca4541c0d9276efe0b64cca7de1084c315d098bb9bcff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "93a1cc693311c5d69f0dd2c65c9dd294ab3ae5cedf08065191026d8027f10dbb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4decebd75bfd953d4de769cc5bb8c6d9ca384eaa8adcf04a1b2e190aa9b09d7"
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
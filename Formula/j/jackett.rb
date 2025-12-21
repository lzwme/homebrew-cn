class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.488.tar.gz"
  sha256 "0d011de02153df1433e6b95871ddd57c766a1266195932a87c28ce9c4b01378d"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6fef95e022ae2afe2cca6446d24b1778d9d4e04e1124560557f424669cb3481e"
    sha256 cellar: :any,                 arm64_sequoia: "873f3648d9baccad98f9187240d83765b24b6ff8e0d2a64bcc433ee7a9512dd6"
    sha256 cellar: :any,                 arm64_sonoma:  "3e0a1bd5c2ddabeda8ca36e64167b01225e0b634e227884edc1185dded77fd04"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f4986f8b806b3e2bee6706c11419ba2b6d0b1afb9c073c8dc2fabfc44ed742ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1972f547e8e71c1e01a2adc45f89fdd2081e0392309df9b14120f6aacb9806c1"
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
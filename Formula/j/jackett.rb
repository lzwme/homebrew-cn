class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.1841.tar.gz"
  sha256 "48150b5344a8d7db318c01872d92d0486c05a781002f40d13605fe4a928b6bc2"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "fed5bd214047afac57f1d8ec221a2ac221eea788b875e4663e3ef19c225937cb"
    sha256 cellar: :any,                 arm64_sequoia: "839630e1ad2d4b480f599e38862d4fdd06b0f4af8f163d6c5e0bad35497a30f3"
    sha256 cellar: :any,                 arm64_sonoma:  "4f0772c5c125576f5e79c47181a023ded2c0799bb591dec3d9bcb7f9c917860f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0e611c10b0ecc32ab815ae173e56a4f6e1ae8e85611ee645190dec0b0d0b0fd2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5beb796be75cf1f81f8030672287d4beb6097071876a8be7ccee88fb623afba1"
  end

  depends_on "dotnet@9"

  def install
    ENV["DOTNET_CLI_TELEMETRY_OPTOUT"] = "1"
    ENV["DOTNET_SYSTEM_GLOBALIZATION_INVARIANT"] = "1"

    dotnet = Formula["dotnet@9"]

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

    pid = spawn bin/"jackett", "-d", testpath, "-p", port.to_s

    begin
      sleep 15
      assert_match "<title>Jackett</title>", shell_output("curl -b cookiefile -c cookiefile -L --silent http://localhost:#{port}")
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end
class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.1526.tar.gz"
  sha256 "095c2cfe8fbc9e295dea4ee00129421858bb3c4a1a3ef20f62aa765ef45d10ae"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "56a90c0e9483d51c59b728868d31a614d832a794115aeed6a7e55b8eae152c0f"
    sha256 cellar: :any,                 arm64_sequoia: "de88f9a50a132e657180cf4d2029e59c9938deb18eea96e9b3e5313ec65eeaf6"
    sha256 cellar: :any,                 arm64_sonoma:  "5b9b66f00d886e9c0269f7dc1a22dd499b06e822405eecbc47e37daae3f69030"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "74095c819ee0689e8cdb7f38187b223fa6f439206908c1d57637250e9f06c196"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bdf0cf615feef10cab8d58ea1685c3d05e3ce2234c30f80d288f520d6f3b880c"
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
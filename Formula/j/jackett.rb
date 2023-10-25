class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.1077.tar.gz"
  sha256 "86ff14df47cb26c58cfaa5214f6deaf89eb543d5db62fa092ea82508c39af90a"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "96d5e30c62ea8d1ce37166685256a3c8fbd03dfaf2f5818be71d9ea0e8237422"
    sha256 cellar: :any,                 arm64_monterey: "aac7465fde077ea8826afe29e84137f9193d82f9b6d42d6ff5f91e8512cf28ad"
    sha256 cellar: :any,                 ventura:        "5a8f688e93da2fd4d65d38cf329e878bf0a585d2eefc34c7886625eabdfbdb4c"
    sha256 cellar: :any,                 monterey:       "b717100eda4456a0dab09ee662944601d37b9597e2ed72dc6b7cac6601446f77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8cdd6d72db15c17e6e8de8365707caa010f1e6d44ae7af03510ef84583875ac5"
  end

  deprecate! date: "2023-10-24", because: "uses deprecated `dotnet@6`"

  depends_on "dotnet@6"

  def install
    dotnet = Formula["dotnet@6"]
    os = OS.mac? ? "osx" : OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s

    args = %W[
      --configuration Release
      --framework net#{dotnet.version.major_minor}
      --output #{libexec}
      --runtime #{os}-#{arch}
      --no-self-contained
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
      exec "#{bin}/jackett", "-d", testpath, "-p", port.to_s
    end

    begin
      sleep 10
      assert_match "<title>Jackett</title>", shell_output("curl -b cookiefile -c cookiefile -L --silent http://localhost:#{port}")
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end
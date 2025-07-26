class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.22.2193.tar.gz"
  sha256 "bbb87f90e0afa3f373852502fe92bf1fe348f7b9c823497d5713edfa765428bf"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "51a93bc93b8c55dfd11c5a0c0fbd682f72c0ba834e2702136faa0cdb4fafcd61"
    sha256 cellar: :any,                 arm64_sonoma:  "980de09d45d5f1ffe15a16f1db8d62acb44075e3e4a27371ada6f9531adbec4e"
    sha256 cellar: :any,                 arm64_ventura: "edd5ae7dc285ca37786e11a8c42a083aac4871a668a69f4fa3ad6254e2b3b8e2"
    sha256 cellar: :any,                 ventura:       "7d75df11e9850e842d730d4230a809d05e32b13c8532619f0190cdcf7250b538"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9d652f813666d468bbf4220c77f0cab8fcec69a2b702a036bce969c347d020d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "accda1e48093e6eab048bab87b3bfea01823ee5e93d21b0abb4d6b2c464a794c"
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
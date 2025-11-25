class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.348.tar.gz"
  sha256 "38361ca97414d02db6ea0d3d86866839787a18d36c38a6568be97db02d247352"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3deb4105968b00749740d5468b11ada6a4700581ced1a3bc691fd32a1091e11b"
    sha256 cellar: :any,                 arm64_sequoia: "e2836bf7ff4efd783efe55cf918089db37654dd484631959b665e4291d6c9fb1"
    sha256 cellar: :any,                 arm64_sonoma:  "431684eb50b6539915d68a3a6e15a85eece09e1556bab3e0ea814abdf78d33db"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "960fd5bc991eb06aff73eea9d54128532bed6e60d0de7590e7098e6e4646825d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aabedb017ae4bc286d90bca5668f106df03592e3a65596e68244937834f4cbee"
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
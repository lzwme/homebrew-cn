class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.1368.tar.gz"
  sha256 "3b849fa00654a8d2588969217e93e3cc8c5ba702d33fd2eef01a0f510d44bb45"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "18a36b4068108106b8b8b69e739e46171958e918fc9373930976e684317ed6e5"
    sha256 cellar: :any,                 arm64_sequoia: "4567c8d184dddab5a11fb1174d490cf3af295bb9090ed9ac2c7e99cc56cb0a1a"
    sha256 cellar: :any,                 arm64_sonoma:  "ea1cc6a110e8067712136981064ddec78fc198f3e7269e2f72b727bfff8dd9be"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e6056695b7cc27560fc8d654554054569b0cf6611d1090455724374b8c4b8371"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8bb508a07295f0efde3962232b0b022eea09f454198fc1f4a25eb6cd0065ec6f"
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
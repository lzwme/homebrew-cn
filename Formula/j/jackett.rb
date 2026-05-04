class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.1815.tar.gz"
  sha256 "37b4eaa9acab948019c500451b5a7769bbb5cc86982a598db4a11b5333beeebc"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4acdb44da227a3e2e6bf00527fc1f5f13a915a5fd82811e282e930e67936ae7a"
    sha256 cellar: :any,                 arm64_sequoia: "4cfabc42116a1af1a60be9c39d8ca79daea03c082f57406ce1174447650afd43"
    sha256 cellar: :any,                 arm64_sonoma:  "270bca767b45884e47e0719061f6ed70f87631f4f552b2aeb185344b212bfb6b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4505a9553f5f6e4affaf957d2569f2e16392db061003eb722d822148debc471c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1594c82f50022b16c7fb237e608df3cc925519a0970752ba1fcbb1f03f4dcea0"
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
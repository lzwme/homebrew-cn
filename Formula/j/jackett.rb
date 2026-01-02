class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.652.tar.gz"
  sha256 "f07739999a94961bf8175c07dbd3c07a47eb16d5f0608f9fc2b635cd3be2caf9"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "100214ad9e4a61fd11978befb147d61fca77cd743190997572395afc609adf69"
    sha256 cellar: :any,                 arm64_sequoia: "242953bf9ecf6f62cad31e48a74257a22647e72d2b2bd2d3c598eb1884db3ece"
    sha256 cellar: :any,                 arm64_sonoma:  "8571c497f90eaa5b7f8dea657fb737f79c0be08b7ba925776573e557ac11bc4a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "126dfb979508b025b69f48e953ec80b194cf424ea6aa6849172e10ac891d7d14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab84ea28bee3f073400145a4da33f06a5106b740d9e9759acb51f336981fc8dd"
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
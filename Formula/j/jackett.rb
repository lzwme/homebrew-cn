class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.2467.tar.gz"
  sha256 "ca6fe0cebde6901491e08731ac7d4355dc28a9ba031c5d25edf553de15b42e60"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "b64ef44c2f7246b8a7bee38f53cf90079dbee47f2531530281991647f0e20435"
    sha256 cellar: :any, arm64_sequoia: "098e253c49d0414c9d6cff4c24a6e59b8132c01b2737b57460a180be98271e78"
    sha256 cellar: :any, arm64_sonoma:  "e392cc010dafea883dfa6e4107d6ccf618e7da9efd97f81afc69c4c78127fecf"
    sha256 cellar: :any, sonoma:        "91a7227f2737d8aa9685e4fcff1627769a8f369230bd9b1e5a995fcbc0374b85"
    sha256 cellar: :any, arm64_linux:   "65fc3166dd5a531098bf689ec09075c1ac161436281867b53cee4830ef346abb"
    sha256 cellar: :any, x86_64_linux:  "25b49e57e39a604786bf7a566dd4b17250e30a3f7c9fa8dffec2eb7dbdc9775a"
  end

  # Aligned to .NET dependency. Can remove if updated to latest .NET
  deprecate! date: "2026-11-10", because: "needs end-of-life .NET 9"
  disable! date: "2027-11-10", because: "needs end-of-life .NET 9"

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
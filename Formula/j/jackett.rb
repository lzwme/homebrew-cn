class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.1974.tar.gz"
  sha256 "3956ffa294f52ca2e4575d63d0ab48734ae9e5a58a5fc39eaf281d79293d118b"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "6f04ba4cbfa6a96e1a73a0cbb945d58edd69f3e9cf4ee42e5386ba1ec5b925a9"
    sha256 cellar: :any, arm64_sequoia: "198e40df317ffa9da4051f4325f37eb65ade67fa179c56dbe6165e33afe14ace"
    sha256 cellar: :any, arm64_sonoma:  "7eb5ba413fef3a306d37811c1fa5d7eb9cc962591898add7125031ec2b641d64"
    sha256 cellar: :any, sonoma:        "34b0d837c90e564c568319d245c957d77876c31c81cf5c95b3e7fb6cd87b65f1"
    sha256 cellar: :any, arm64_linux:   "e152b9cfcb1aba30aad3d382ff1358eff670a7acf2bd195e704598669d5c2946"
    sha256 cellar: :any, x86_64_linux:  "3cdc41c232432fe74a3b72915ad88107ea12c26ba7d6cab65894fc0823e33fd9"
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
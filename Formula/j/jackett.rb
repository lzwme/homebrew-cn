class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.22.2162.tar.gz"
  sha256 "125ba3800fb780fa153a37ff17748842546403e3b81960d27721a068510f592c"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "124747c3518e16afd6b1e288cb59c52667fd096439b0db3ff149f2f602c69303"
    sha256 cellar: :any,                 arm64_sonoma:  "7d8e48e766a24c25ffc934c7c64c1622f7f31560229521841c9acd86a5d46af2"
    sha256 cellar: :any,                 arm64_ventura: "f65da27e6cc27c35fb9a362a1c5540639d25abe03a2e8eab58e7eeec3eebeb68"
    sha256 cellar: :any,                 ventura:       "8d13a5cf2eac4ae2aa510346dfbd7b4fb4e98d067cbe578335d18222df142e80"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e30b2afd61528d0bccef1801c1bbadf8b39614bcda818d69c67933f0cd33b909"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "877d70c9918cd7f50d449747be62b70064c7eb40dc728f26d971798144dff34a"
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
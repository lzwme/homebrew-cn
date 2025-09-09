class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.22.2441.tar.gz"
  sha256 "671c268c13a9fa99af329a7540a23ea289f4d5cc578a79fcba4642b06a40225f"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "567c96cbca255c0fd0ee06dcb765f866a8fd32aa2b5b2068beebe3bf976d728f"
    sha256 cellar: :any,                 arm64_sonoma:  "f863a0c714d4594a07cac64032c3258979fc2e06a73de2caf7c1feae5aff775f"
    sha256 cellar: :any,                 arm64_ventura: "912c2cfa15466edc93e1eaa030d8eae8084f143b8598d1ab63f68689a4862b81"
    sha256 cellar: :any,                 ventura:       "7b9a95cf6165d8164d00509338a5f2e49220ba18143253d8765919683e4853f4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7ee4a5948f48a6762a57141031ff82421dbeca34841cec5d3b3ad3daf6447552"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a546ff4a51c7c90b38cdd59cf4ee6f5c46aa99702ca0f3978e9aeb14eab2cd03"
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
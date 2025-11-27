class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.360.tar.gz"
  sha256 "4232c2f65cf468832bd16ceeaa86438e3f330257a5e6291998c8da29fac88412"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "37698ee0b91e69e926614434f92a4187941b0b943696e2dec2d0d17868fadea3"
    sha256 cellar: :any,                 arm64_sequoia: "47d7fc30d6f3cce6e8686322ec8e3f69ec35dfe461e64541d97ab12446b41c67"
    sha256 cellar: :any,                 arm64_sonoma:  "19bd1af1ea576f23e77fdcda754195cbf5b0f5141892729c563474e491b35079"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "02c5001878357577d3f2b6bfeeef994baa9dc0c8c0279ffd2a51586f49b46b3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "df84d5efcded0a96dac67b53324fe477b7f5f3024bb2c08f7f000b48494143d6"
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
class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.243.tar.gz"
  sha256 "9f1014b2ffc2bd52839280643df82a3680e8d773bd932a56fd18d84c3df74565"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9ba1eaa2eddc14d116312c6d97aed65f52af03846c0dc17a0dc29f6554befd9a"
    sha256 cellar: :any,                 arm64_sequoia: "1a598d5664c0c8a49622080793ed876d87af808a672241dea8288e985f0b8a91"
    sha256 cellar: :any,                 arm64_sonoma:  "b5a642a94a95722434027d700fe2e7d4932901fdfd8edba5cb43b44be33b0c26"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cc30102eddf1025146ecdf6842138dad85dfe887611ce697a09ef5df5ce6a540"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be1ebe83495d54662a25a6a0f950ab06a5237d6ace25966c385f594a6d9531aa"
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
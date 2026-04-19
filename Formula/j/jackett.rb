class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.1616.tar.gz"
  sha256 "ec9712394ba68e2a39612211c94225e6f1c85ffb14f2f209d1875866c64dfdeb"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d0ca4b4cbf59b32b700c8f9b7dbd5ff7ce61f477b555adca214ff68fef224187"
    sha256 cellar: :any,                 arm64_sequoia: "395ef5f66114822ba02f0a4a42d3ad6a3e171bad159800a6e66c18854173909b"
    sha256 cellar: :any,                 arm64_sonoma:  "1feba3fe6992ddb9138458170e6e6e94bb04956c6a58e474f105147812b563f7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7dc344c15c1ae59a85886735b6f412dd04648677cf798fb036445ab95ae14b38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d6086f1a6c20ecef80432a2558cd597e46f5fcd2329853dafeccb2c1fada1a1"
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
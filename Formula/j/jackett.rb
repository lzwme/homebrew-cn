class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.1332.tar.gz"
  sha256 "70f84daefb70e0159e351372079dd85a1b03539b43fbfc706106fa32b22143db"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "80b63fecce2907c9c637e9ddc66f1f610b9fab72a3044d9fa91d89d6cf62d1c0"
    sha256 cellar: :any,                 arm64_sequoia: "ca8c2fdee7eb1161c226082aecfb7dad746069ff5ad8e25244b2df7b16de7f4a"
    sha256 cellar: :any,                 arm64_sonoma:  "7dd66c161b7a30b04edbcb9c29c2a52c0594a2cb76af995a276ff9d3eb500c8d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b1cff25adc441323383356095ea53f28d0e2fa9a7f941c07b9eb2e1f222689ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6dc956e08f0046022285284d8aaf97f3a2343577f3c8812677cb44df30862214"
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
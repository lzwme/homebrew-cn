class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.1591.tar.gz"
  sha256 "20135e678306f6cfca1a48f8745d9da14b11a5bf8eab207e930349ed4e1994e2"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "62add483b6b542e6ef30bb3e3d3c8ff47571b31dfcab1b22a3c7def7e192b7b2"
    sha256 cellar: :any,                 arm64_sequoia: "27a03107003f42c03084ad5b6b94f695285432d4c9da6dfe0b79a125886f87ec"
    sha256 cellar: :any,                 arm64_sonoma:  "3fdb159d2d195f17b59c6bfb61d3a89c94865dbd5c123b120df17c0c34b96867"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "49ee9f02bddcb321f03810a09d20d130cec21a92658ddc419ea950042fc8c362"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2926756d095d6d499e275f9ded4a656f3f750ccb8d225c61d597e365a17db5b2"
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
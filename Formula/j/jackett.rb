class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.1464.tar.gz"
  sha256 "7eaee28efcb82d5df755288899dd9b8a44df95b8a7f4e5bb8be4cd76270387b8"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "bb088c807608079f69d418035080cdce567c45fbef65ee436c6885c165576108"
    sha256 cellar: :any,                 arm64_sequoia: "8ccff138f763503575526cf4bfc10a0f9bb7934b3c50c1edc2d25519bdcf23c1"
    sha256 cellar: :any,                 arm64_sonoma:  "670f717df6212619baf5286ab097574b368c0fd59031b914daf6cb7230d95b9f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "baccae27bd052bb4c587eaed0b265b54b797690242e34e222627950b492eaa63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "52cb4cb913f6219a0610b3a49b18821f09fe7787c34c3cb4b6123ae3b5bcfb57"
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
class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.1622.tar.gz"
  sha256 "1bce77b4d50bb0adb7c16183f639687cff969c154196086a338a3460d5cdf6ab"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9675131ab2fa8849d69f709efcd008f5146d902bbeb53926076df0606fe02265"
    sha256 cellar: :any,                 arm64_sequoia: "2c900e860077b70bef019d98f0a75f6172d79b1ad07cc2a3027a474c103c73aa"
    sha256 cellar: :any,                 arm64_sonoma:  "dc9f71ab04fd41dda533fc6e6e9503b2414a40b63a94a5bb51a18073d38dbb11"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6cb5e987268a7787b92a76df79c2a1abbd6e80c68376d1b271c95500322a228e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "692162bfd5c50bff4ac86daab7de3a5a9a86960ec9c69d53d6cc54215bf0f055"
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
class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.141.tar.gz"
  sha256 "e5527b05f1aba083818abb78c532f4baeb0f0570ada0a4c8417a6541f6b2fb34"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3eae18a2a397209e30d4e565458064242ff9976a022b25f968bfa57944d1a7e4"
    sha256 cellar: :any,                 arm64_sequoia: "d52d03501be42fdeb1589445c387e003184a8d9662ed60557020918e521d7f8e"
    sha256 cellar: :any,                 arm64_sonoma:  "5fc494d5574f09b2299d58dd77c6913f961eb551dc5c3b29f58ccb3d66be2216"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2513bb84d69cf63254693b9f9a842564f3721c9a8e0bb9541bf62b0358ff5962"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e2caee265134b0895caf96a3e7bf23742bdd8b2db0b42961473e9422023c49c"
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
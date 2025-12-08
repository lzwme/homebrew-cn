class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.415.tar.gz"
  sha256 "9896d6967c30823b24b292282b17a08b32051bd2029d4e0e31660a7deee8f2a3"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e20b2092d2252f915f57bdc0eb7343c553a5fe252631e4620502dda5ff3348c7"
    sha256 cellar: :any,                 arm64_sequoia: "3807646641131060781db43248be5b32eaa045fa1ff7d8024f0945b7df238da3"
    sha256 cellar: :any,                 arm64_sonoma:  "ffa913b9174154e8f38567a6c3f76fd0169cc7b93e5b343be9b540d81ee6082c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4a40e41451752113117d36c72370088e3ee6873eea054ae13c3868befaa78717"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "23ef516d327a693dcea7f5bea5b0fab7fa012b62b1a782c2df353138a0dea939"
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
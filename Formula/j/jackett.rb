class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.170.tar.gz"
  sha256 "ed3fed437afbf6a1e14a820d78c713b4f3bd015264f9846aae8593efcda4b8c5"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "31fe7fbc2c9ede9954690d4884c762fb8195eb0dab97e54a9725dbe9b80c001d"
    sha256 cellar: :any,                 arm64_sequoia: "554de734048c3af00d91f33c15050c51cc12cab2ae4c176a80dc695657e6b962"
    sha256 cellar: :any,                 arm64_sonoma:  "220843221705f7621d02811cb36b01dbca00066da4daf1df465166214e77b6fa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c1b113980dd6d7a503389c9ce967909e81f2be5305054cd795d40d6594f26b57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ada95d262b8d374c868651e23b19ba17f896c4265f9371abba30b088b6c0ba68"
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
class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.23.52.tar.gz"
  sha256 "62d6a9c1e4d880dd007133f9393d073ea00b2327e8453d28acc592d431a8f361"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4138bf686bfcd492ce9c7949b964c4a0b1b52b3417eff996d61553dfd69ac2dc"
    sha256 cellar: :any,                 arm64_sequoia: "912f155a1a023d5375dbfe4df2318bc9b45bfb98a6dbff8383fdd0718ba41bde"
    sha256 cellar: :any,                 arm64_sonoma:  "92439a306b03d34779cb2ea265d326277505336868f1760a5a0c9ebece1bfc46"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "72a02e36e84c331521e54016414402caab201ed463eae75a54f8f5d8652679fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5a27b8c9007e61bad29b9a161274b4fb434542e719ce3e4bcad9139edd5ca863"
  end

  depends_on "dotnet@8"

  def install
    ENV["DOTNET_CLI_TELEMETRY_OPTOUT"] = "1"
    ENV["DOTNET_SYSTEM_GLOBALIZATION_INVARIANT"] = "1"

    dotnet = Formula["dotnet@8"]

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
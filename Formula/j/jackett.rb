class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.22.2200.tar.gz"
  sha256 "a08fb261ef7e23fd844007f027818e8d099616276259ba69c4bc31444ef1aebb"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "fdf380abd4b6e0bdf7f8c5030a52afcbede6ffca3fc5b0ddc2e4c6cb97a9abeb"
    sha256 cellar: :any,                 arm64_sonoma:  "b75c443c06b812837358532df1d3bf3d6477d1748c89d58018c0f54829c81abb"
    sha256 cellar: :any,                 arm64_ventura: "a8ce2a2a559a96689eb10bbe457a8519582ecc7f0288ee47269c269f44125a4b"
    sha256 cellar: :any,                 ventura:       "7ef057e2af9e09c2d5e91d26aa1821c461f8b2442da756931f66835777757c32"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c35749b3b038ad6696602f313b0dbd365676629f80607a03167198e181779e3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a3b31da2b5e9cb81313665ec3eb3b74af602714ef8815cd2da6634cc89bcb988"
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
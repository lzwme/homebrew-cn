class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.22.2182.tar.gz"
  sha256 "5b193897c2e66f3fbfade31e5c7ccd5d1d087d7f086f492784ef792184e7b074"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a60944ef9bc15c185ef6a0c739c6055365b2025bbb5b5a8c4630f4babf998f54"
    sha256 cellar: :any,                 arm64_sonoma:  "099aa2aaa029bd02ad4831f263baf6bd1e5dd2187cb52d5f07ee569e6aabc1dd"
    sha256 cellar: :any,                 arm64_ventura: "cdac22483b3634bbafd4bf20c019af1d688e8c274cf6ededa0750ac6cb0c949e"
    sha256 cellar: :any,                 ventura:       "6e3e4cb683ccf0d48d1e109ff9af3d0c5baad8244c735879ccc183fde8cecf95"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f475bf0e8c2c153962106dd96289570854f6234e4b01fe9451be33feb6228841"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5edd824c585c874c56ac81d20bf94dc43b0d99d9c15c0b33fed952cfa4e9ff24"
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
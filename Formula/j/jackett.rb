class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.22.2418.tar.gz"
  sha256 "1c3898974385d0a49b8b5be42831b5dd2055e364955f5ae04f7644db4377def3"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "842c33f004f3e3495d657525a633bcc90e3075051882ae0ce05cdffd821f3e1e"
    sha256 cellar: :any,                 arm64_sonoma:  "bd92c592e5377621b61fe9704aa39ea99d605ff950e532e25141ffe78d17db8f"
    sha256 cellar: :any,                 arm64_ventura: "2c2ec75329675ce5e4afdc5dd59ddd26ef9226384e71894d2c51ac858f988db1"
    sha256 cellar: :any,                 ventura:       "74f76cf2bf99bfce078471b817caffedab841c14d8e1f94ec1c638af18aea585"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fdc89bd9c5c0c9c6ff595bda85384065de6355e8f8e2fdd343ec45591310d326"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "07bc2168425a18e1e244d1c614df65aa7fdf7ee654e03c7c3393f79cdba7962a"
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
class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.1831.tar.gz"
  sha256 "7727552736bdc06308fc979d4ea5ab35c091fc5353f4ae43b130acd60e32380c"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "fd62f7b4c02607b74bcc8a172516be62b615a00a6daa3bf796a27305b77c5c88"
    sha256 cellar: :any,                 arm64_sequoia: "72a99bf729e4fc63c987f60a9ba94c853d68cb629c06067b99e09cdbe04d1119"
    sha256 cellar: :any,                 arm64_sonoma:  "9f92ef566610f0711dc7484d8210a1fc2a6c4a02aa52b0d340d33dc6f21e3f25"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "47f86cad6c6d4711bd502ec4d633e9d434daca452466f3ab006f1a604ea6175f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cdef0fc183a9fab6d61121ba0d63c1ce96e569a9e0f732971341840e6e7e359a"
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
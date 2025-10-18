class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.145.tar.gz"
  sha256 "9efe563eaa9dd4ad1f151617263bee926c5748983c1e53d2c147357185d888f3"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "983d1d5602c3fcfc878dea9c1fd0ec1dc4d4fc508a82321348e0bf9b9fe7c1da"
    sha256 cellar: :any,                 arm64_sequoia: "482f78d1ebe1d65bcd8b7e4f2587a6b6376edf91d3942739fc6297bb1499c27f"
    sha256 cellar: :any,                 arm64_sonoma:  "32bfde91b5940fe4bc0553a06c06082eb6ef2970996cea9e6b3d0bb8748d2299"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "30c90c2d6d17af637a6af38a19cd26b746d986f95500b8001014098a9337f1c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be3d6d9e4161422dfe409c252db1ae13284a54441de2a326b2e6c41a6efe6900"
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
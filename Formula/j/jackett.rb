class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.22.2233.tar.gz"
  sha256 "034c76ae6ef28ee01ea59927e12d30ed8a88f52de99df139826977634c3a6b5c"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8cd699a76ba8d78a831ee3d26bc8847e7b729554f5f6d1dfca83a41caa6ea873"
    sha256 cellar: :any,                 arm64_sonoma:  "80177e417543339e798702f2fd2a2ffd0ac2b4843f2346686ffb1186cedf49c1"
    sha256 cellar: :any,                 arm64_ventura: "2eca584be1259dd53334d8e60daf9e3f6ce50a01739ed4a2890f60b74c1d371b"
    sha256 cellar: :any,                 ventura:       "0093fa4c1f8fa40b998dbfb7a04f4fab1726893443ac76ccaf24027508dcb4cb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d0ccdbed5573dbf4fcef36f93bca428713bf58b455f5271ea8acf5560e27e5a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "89b62e6fb75465577ef57facee78db6d2bd8054dea7cd4e33372268c8fa86e55"
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
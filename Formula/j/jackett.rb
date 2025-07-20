class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.22.2165.tar.gz"
  sha256 "785e3e4237c96ebca362da1a7b00c0ff2ebda4e1a0f2ae32930add52dd5edea7"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4c488dfd6b69d38a0e0f30aeb0908b83d8e3885eb5c886b352f58c95e763ebf2"
    sha256 cellar: :any,                 arm64_sonoma:  "165506775627b90c1ceb037eabd0799e9c788ff39924e857ef622d0ada21a81f"
    sha256 cellar: :any,                 arm64_ventura: "6f77a5550320b634114f2ca14bcbee968bc63442cb0d636f36170b613d29e156"
    sha256 cellar: :any,                 ventura:       "d93c66e5ac3a0c53a6af4ab159b240f2ec3600793020ad52ec4238b3432c9b73"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "96b331b6ac44f43799e71c82469e9b4555e20e76371ab0b0ea47771b20e3d2d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1348344a8e39c723a03525e53a68304416e864f55dcbe961367dca94f9cdd097"
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
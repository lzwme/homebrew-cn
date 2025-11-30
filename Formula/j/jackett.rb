class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.372.tar.gz"
  sha256 "76a43804aba44ad9f89502aac4aaa65604cf8b58b2a3fa0fbc0c46f532e74168"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "99f5b51bff749bc926d8f39bb0633397251171a60bff4555c130b517c848f9e7"
    sha256 cellar: :any,                 arm64_sequoia: "b03ddff8f8342349e1063a7c8d04324a95c460494498f02ef20e73158f2504be"
    sha256 cellar: :any,                 arm64_sonoma:  "237402dd7bcf5d26da47d1e1048191da3f9a657368240c3fce4b29569016313c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4b489737fbc1c9f585cf0c3d8ca09003044d31ef3e55399a5945d350f06a6549"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "69b85200b10e2f37ba4341e3c623628dd68adf753024d2f51175517c6acfff67"
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
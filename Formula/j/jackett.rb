class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.23.62.tar.gz"
  sha256 "b9981ca9210dd3752ef6a603c7cced729f44cc6b7b38c8ae123a20866dfc2577"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b37f26b61208a8ab745567615cac280af9ba4edce41fd2146ba8bf4e7af7b40d"
    sha256 cellar: :any,                 arm64_sequoia: "b28b5f0e641305e4d668439f37d7a620abbd6f06f64fc1e0d43e943d5c7b7392"
    sha256 cellar: :any,                 arm64_sonoma:  "239c3492a7e37eddaac42cfde518375e2edb614e49b0a2887ff388d084f7f1af"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ae87c0b0dc8d747eb559ed5d902e83ec9d66a1a6e5586e684e02f8600a01bb29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "042426c82e322fb2b30f7ba07d32cf791ff265eeb5b9f214e621fe546a8c3068"
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
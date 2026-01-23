class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.900.tar.gz"
  sha256 "03bbd368651f26c8dc1f45827342cbfa3dbd27a93ca1398a8d09036bc723e8de"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "bd35f029b51bf4b9b9b6f86517e7dd985b1c261a2a21075ff45073d886c79462"
    sha256 cellar: :any,                 arm64_sequoia: "137ef67b369c0594e7afab0b8695b4c93f8569e199c87f72e0806541737f550b"
    sha256 cellar: :any,                 arm64_sonoma:  "fee8a13116fc93dc132c498922fee163a42ed453a504d1ee339096902a47eb0a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bad36f80462ec90c039d3279f69708d7e4a1f94475e509a5bd69a898fc885e90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ca9742b6f72f6dd4097caa72ae20219a3196cd3a2d307fea5886caf1479e8c2"
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
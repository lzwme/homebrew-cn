class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.1218.tar.gz"
  sha256 "dfc32bc7e9bc6e8dc2df6d8ec9290004da65bb914140b399f82d8f1c0703557c"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "821936fe9f8ee8e1a85b523a31d3cd22e8874545e21992af6ca89914ea412f10"
    sha256 cellar: :any,                 arm64_sequoia: "3f896a22b4de603f94216e8281d1f70cb9d76b44089829dbb0c5432a8551fe85"
    sha256 cellar: :any,                 arm64_sonoma:  "59e56d8d719a5d852d88b3d9773bb345028e22a446a2d9c264399413de808522"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c91e412465022018db43b3db29fa81cbd0510b19f6dbd1dc461ab18704199cb2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "16e728ee93ff995797edbc268f5ef85cb3092da57c7162e9ad909eb18e638a2b"
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
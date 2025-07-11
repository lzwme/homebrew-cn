class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.22.2140.tar.gz"
  sha256 "f9a216c4e37aeaaf6dbf71db27ed5895004a6f5810b0e8b003a768594133815f"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5324789d2aac81d942b95cc340406107096c4307931a22348638c3271fe3d738"
    sha256 cellar: :any,                 arm64_sonoma:  "a27c22bb53cc6577393cb60b39cc175dbadf6f226f22ff98682fa57789718b12"
    sha256 cellar: :any,                 arm64_ventura: "0fcbf497c425ead0871b8c2a0371b2bc6c20b1857133050f6f7d907742dbd0e8"
    sha256 cellar: :any,                 ventura:       "ca3e3609d9e1782b28b67edb5666e8b60786b9f619f21c58d75a7b50ab90c216"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f133cb5de0945403060a6be0143638ec255a670071b015bfa76d443d302bd230"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f20f4b55f10eb1f497dfa722730810ce25ab48adf46830206c0f044c1f28c502"
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
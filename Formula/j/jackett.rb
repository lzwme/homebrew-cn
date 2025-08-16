class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.22.2288.tar.gz"
  sha256 "a3f64d1a372d927f2777ac0ad82fb4ae27be94e501f502f983a72fd562cf0e14"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "bdbb5d7663cfeaed27d0564ca316145922cc6efb17bb78b963decff2f181eedb"
    sha256 cellar: :any,                 arm64_sonoma:  "00eb7841b0fa8b83a495862f6f343fb6a9f453cd4dbaadb678dd2a652a645b48"
    sha256 cellar: :any,                 arm64_ventura: "50508450a021a972fb83df907df99fc9b1929aac057e3aec1c96682b3a302020"
    sha256 cellar: :any,                 ventura:       "1810a835e487f7f4c69b4c87fb834144953be5537d8934885040874adbe442e7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dda39a75ec350559f0b5365aef2ce283627f6da2a0ec8dff1186948ae621d8a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f28b6c1d6c6ee6ba7de40d8592e03ae92734303cb6a3d992a378af38cade1dc5"
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
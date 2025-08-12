class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.22.2258.tar.gz"
  sha256 "3ba35dcee9916b6364e1e1f5dfeff5401ea6d5359caf0be2164a5adfe3cbb540"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1f3e4c6d8ea004c014bfbfd3ff1076f915d6ab3e5db755d61304dcd6dd744405"
    sha256 cellar: :any,                 arm64_sonoma:  "412dbf7b28d5d87ebc175d2c19aee63348f6144d05f1e5c8b279a263a6cd39b3"
    sha256 cellar: :any,                 arm64_ventura: "9ea86118d035db1c8ccb87d4ae69fc87edd8f1de8efe551458a9cfc5430696b3"
    sha256 cellar: :any,                 ventura:       "6f19f03b0b594ea1c6c4eade84752ced52217e87deb82d226ce8682e906058dc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "43bc5d4713e567ea3de773ae84f151da0384d347ba271f2b2fdf4ea5e32a6db0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b3cf81d434f8ca03f78f142dab8e10d5e93548fbf0bf285de1f5d1a006d9e230"
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
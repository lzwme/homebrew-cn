class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1917.tar.gz"
  sha256 "7a75c12e887a6fe2a3498f03f4caa7a7f039887460def5f45c7ddfee929a2168"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5c7f4088feaa7f9e2f3d59afa5b2277d514a3fe5e67618caafe84c30a17dfe64"
    sha256 cellar: :any,                 arm64_sonoma:  "7e8e06ed49d3c61362c079f3cc6e3ea79a0cd64445e79b4de6fd9be165f6a98b"
    sha256 cellar: :any,                 arm64_ventura: "99f363373ae1924a50cca1c2a43d2aff4623586eecf770e44bd3ed894604b52a"
    sha256 cellar: :any,                 ventura:       "cc0ea7cb6502e4a0f39a3c0eb521b5e4285425366f24b5b3215d9f9e88aabf46"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c54e95a98f18f8684a0b506f4319399bcd26691cf9fc58bc0ce4daebc312cdda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a6f5c5fb91bf9f7fa092e156cba54916b732c991da346110a68ac4b4c3d61a00"
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
        p:AssemblyVersion=#{version}
        p:FileVersion=#{version}
        p:InformationalVersion=#{version}
        p:Version=#{version}
      ]
    end

    system "dotnet", "publish", "srcJackett.Server", *args

    (bin"jackett").write_env_script libexec"jackett", "--NoUpdates",
      DOTNET_ROOT: "${DOTNET_ROOT:-#{dotnet.opt_libexec}}"
  end

  service do
    run opt_bin"jackett"
    keep_alive true
    working_dir opt_libexec
    log_path var"logjackett.log"
    error_log_path var"logjackett.log"
  end

  test do
    assert_match(^Jackett v#{Regexp.escape(version)}$, shell_output("#{bin}jackett --version 2>&1; true"))

    port = free_port

    pid = fork do
      exec bin"jackett", "-d", testpath, "-p", port.to_s
    end

    begin
      sleep 15
      assert_match "<title>Jackett<title>", shell_output("curl -b cookiefile -c cookiefile -L --silent http:localhost:#{port}")
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end
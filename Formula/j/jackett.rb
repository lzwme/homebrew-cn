class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.441.tar.gz"
  sha256 "74b19f734d4d47092e00f13ca57a6281f5a5d7364659a55657d09ef3573b2a04"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8834b09a3536e96bb1e6c0d1a9d96f873a103996bee60d5e42b282edd6c388e1"
    sha256 cellar: :any,                 arm64_sequoia: "63caece1d202a21e6569c0e6cd3d1b4da89e9d9afcfea8f87d1fc02a24275cbf"
    sha256 cellar: :any,                 arm64_sonoma:  "918f73fe6c1da2ecf55e82b564d3adeb9806ffdbc3638b26c39d3b4d6a391df3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fcc0851e75a43e99b18d69b5b9978e2d2ae198ee1db73b96d5d95a9b370149c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be8167a295a9cf390457874c6059cc45448185026e542736ce138ce8441ec17c"
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
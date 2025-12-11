class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.429.tar.gz"
  sha256 "0c715ab83a8351a1eb71b993c1c7b15a1b677cfeec323f0cccd0b22d1455187d"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1723d42fb9e5b75e4943c2af872507972138cdc59a91ec0de5fdadd5e73c33dc"
    sha256 cellar: :any,                 arm64_sequoia: "c53c6610b39a5f4b8e5a773253e8004258c8d44d022da758844b50b0f69333ad"
    sha256 cellar: :any,                 arm64_sonoma:  "4cddd47098f49e4c20053a56ef573a2a2cf32c4403ac67ea21f1f510aa55d826"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fb267b427e924d04b356ffbf1c2e7cc896ad90664549481b3fab5006c1ac070a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "71c0aa88f3bb63f1f2ffde66feac9aa3956800eaaef41aac9d410eb61fab76b0"
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
class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.23.12.tar.gz"
  sha256 "d9fe5ba3f24e74561b14ff0720062e9038c6be05e447ba960b037d5e6126d9de"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "26fa683eaec6572df3d47b48b3f2d48064ebb820158fd010759944109d827ee5"
    sha256 cellar: :any,                 arm64_sequoia: "1da12f3af8011a2710e2ba7942f05bb1eb5c52096723b2e8b6f2383ea66d6ffc"
    sha256 cellar: :any,                 arm64_sonoma:  "eae37052d93c8f28186498091714c288e9e15235b0aca640143a286cc16082a2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a03ea039849fe0f839a4eea7af04556cd58335f7f2a0faa9f404666ecaae97bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "59338d56bc3c2b66eabf11d784e91ed2dcd3e7bd9e4f5ee0e91a337e0287022e"
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
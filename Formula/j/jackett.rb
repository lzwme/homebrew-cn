class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.338.tar.gz"
  sha256 "fbd4658a9bb1625bc04d9f79ad5f91347622787635c3891e31b3133fe4a08218"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "79d18e77df7624675ba9ed92d4e91b66603b97ef6c64d1ab86367c5ccdb606e6"
    sha256 cellar: :any,                 arm64_sequoia: "d18ddab041cb55b152c98cfe7fd3551136526a24c4c72c2b1aa8025f3451ec14"
    sha256 cellar: :any,                 arm64_sonoma:  "f738f35a47984ad504c54b02ae08f765dd6e43ab69d43ddd538268b0548fde48"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ea8bcbec527601615cd8077af5fb1384bd348bcbaa71b677cf7f00ae1f5f2286"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1d00869ca1d5915df835eb338d4a5ff70b5106db68c54f872aa6e8e2e3faab20"
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
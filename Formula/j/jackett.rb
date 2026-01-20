class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.887.tar.gz"
  sha256 "aad22d302e8f0f3fabfbbadca80fc9658282e67798ee02f339ac1666b5cbb85e"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "367122b2d870d95fc8bd12f9ebdfd73fa5801eb3bea00003ae194e6e6ba24d22"
    sha256 cellar: :any,                 arm64_sequoia: "6fed4f1130408a109fd0b3b266d5471f0dce2b97deebcad313999b3abeadd07a"
    sha256 cellar: :any,                 arm64_sonoma:  "24da6bc09a6c811809ffeef3c598a432bbd67856a8ee3e7853b1b199897e4e3f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "37976c01c7c14d9094b01e6449da8c3f8b8ebf7bcbb64583fc0a92dd15be40ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fb038e257f937d68fc5d9856f326a50320d6b014cf16ba5546b68cf6a026921b"
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
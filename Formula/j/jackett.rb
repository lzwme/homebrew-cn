class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.22.2431.tar.gz"
  sha256 "8331a7a2d9af5206b7403747d36148edfc94cc4ac02453d075711796b4d38fc3"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f278f68c8e4e363305106b256e615a204ecfcecc3b195a96882d8ce73a395454"
    sha256 cellar: :any,                 arm64_sonoma:  "207334cfc47a257f6d72746be37ad488e43f1c4f55cfb06a8bc001d65efba9e5"
    sha256 cellar: :any,                 arm64_ventura: "c67045a1e8ed3a3828b6a4484b8cfe42c3a0a7e13547d8baf37ba16dd0501922"
    sha256 cellar: :any,                 ventura:       "9b3f0708ef72ca8f1bba09a6be51bda86308cc9e48a551580d157c68e63661fd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ffd2b2b47f2950d51c6456a316c5a906057a3cc676af4a1e944cb6c925e79276"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "58891e91ed981a7cc1600afe95478969f30bca5f93373274d68ea6c8c575d98c"
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
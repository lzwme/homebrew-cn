class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.671.tar.gz"
  sha256 "d20c4087207c624e60aceafbd2fd9e3119aa634c0b1b3f3e8b41fe6d7021bb01"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d89ed367328a16d0311189908361d113f91454d56c27ade02aeb85a5f28ddeed"
    sha256 cellar: :any,                 arm64_sequoia: "945e8c296acd0f2aef6c2f049138b272ee41f3c9670a77e5e557518c6f4089c1"
    sha256 cellar: :any,                 arm64_sonoma:  "cbd937ad8cf7cda6125cf7d6b5db7b638c9f8002b32bb88dfb0afd999599aa95"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bf26c8ff8ed3391a59e8f704816cf316132d1f3b3377beb89a0ce5b6bff2aeab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "98c92be500f7598c11609fd016dfe0ba01ea94d4d71e1bc38d21adecf05aaddb"
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
class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.383.tar.gz"
  sha256 "6430cfb2b0fe3026c5b06090f92bcba978993453f26cf01bfce7637f817bed96"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "35e4e194537d95c0e66bb11621bf1d48aa6f02342c5699ba3a373f22376065ad"
    sha256 cellar: :any,                 arm64_sequoia: "b0f76d251a473be0b55d534b50818012bc5c52a0f3fda07e68178c5008ff00cf"
    sha256 cellar: :any,                 arm64_sonoma:  "0f57dce76a789516ac6c07d5da8bf3122f7bc5d7c8f99bbcd4ee5d7fa76d0603"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "69c015261068f93aba365f254738fe7dfa3f3e0e6fa8675afbf44f083bfbe648"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b6a075746078217a5bd24028a0f67f1c92ad70214d6b7fade6beccec35d7e9a9"
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
class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.645.tar.gz"
  sha256 "a59ddaa3665bae1fb21d20d8e8e44cf8235e755c9b827958173fa4450ef1aecb"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5fab6d7f8ec4f8f9d0f8f1d82efe9930b0074fa572d3630cb2cf307673bd4f52"
    sha256 cellar: :any,                 arm64_sequoia: "cfedf09dc60e7fafb87466b92bd0241ff322128f9d258db607c2ef983f46c0c6"
    sha256 cellar: :any,                 arm64_sonoma:  "312012f3791e055d4b204857da243df94948e3bca11ff1f0c0da4ad41a21da07"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "124793dcd7079e277e15749c2ba4126020c7f316ec9e3259f40eff6d0342badd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "05ca2810fd135513b74f3ee94f41a1672addd2b83442dce7ff47210b3a828e45"
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
class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.1764.tar.gz"
  sha256 "8c89026337d329ddbd6da2d9c82875b93d59c1ce08a9c3ad5cc73d350473fdae"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "24d6ee4e784b333fe8c49f2bd9a55d70d0b42433e2dcda6ceee5ff0e9237379c"
    sha256 cellar: :any,                 arm64_sequoia: "1c780a613bfefe2a87d59b63da589d373227095cdfc7908d07345bacb5b68548"
    sha256 cellar: :any,                 arm64_sonoma:  "872f27cdac4c99560827b6f7627b36c644bca841392c47b46d978d5644bf7418"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a5e9c3b5574e6c0647804e8e53aa601c7797b47d6f0d826e97d1aa27d5b36305"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b30e37ec4c08ea783db764aefd39bc7565964105d02a03ee1244d60670ca4c33"
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
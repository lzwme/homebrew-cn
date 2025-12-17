class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.462.tar.gz"
  sha256 "2d9fb97cd85596f14b7dadfb4ed0bc73aa32a77c6022d56c184ba92dae2b1701"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9ccdc4bdfc6f13d6490af8d1d144f7daea759f00c1acbc5c669c3b13c6c234b9"
    sha256 cellar: :any,                 arm64_sequoia: "c6f0d33afa73b7b235b2cd6f965852441f387447e82025f6a76170705a507443"
    sha256 cellar: :any,                 arm64_sonoma:  "f404af716f8349b6fbdedd41e7aeb4cbca632521228889a017d7a50ccf5c58ec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2ae3307efe5582dc1c642cfbcb7703c21eb0b4b3cde1905041d0dffd23857c6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae7f9c9b434ce6605cab342434950598ad2def4d99a1fe796ea0d6355317242d"
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
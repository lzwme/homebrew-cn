class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.404.tar.gz"
  sha256 "bfff04c0a1a39a401d359729e81e290904c2045ebcfd735783299dc5aac669b7"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3ecdd567d87ae441c9e3ebb4c4d616c7f4fc295a9042eaf5268af7ec81eba625"
    sha256 cellar: :any,                 arm64_sequoia: "84fb28bc79d8281df4d01251ed61118ac8a29707e59b5c65a1c63fcfd755b847"
    sha256 cellar: :any,                 arm64_sonoma:  "a3e0c6c97bbec5ec1865abb46ba5d4d9af1abb163f954aa374c7a5f475c6ce19"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3c6f19061abc4522c9de943af52b90d948db9aabb1e6d7a39d8830319a033e88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "45475673dc61ce986df9a3347c72264300fad19bf6669f966daddd4ae666576b"
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
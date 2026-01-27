class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.946.tar.gz"
  sha256 "84044123ee074942cabee1c763189eff6882b4c519df66bbf03a4ee45c241927"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f16fe1b56d1b5912d9f4d047cdfcda6ab3021f91347bf30d501d69ae9c84ef34"
    sha256 cellar: :any,                 arm64_sequoia: "72567a6ff6b8ab7847c2e3c1c687481db1ef6a4838e90e0ad09ab0862e5597b0"
    sha256 cellar: :any,                 arm64_sonoma:  "f5ed410a0121f4d9e42ee7d16ea1ea83e3f65e06715466c77d71ed6ae41a704b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1d354a0c8c06983e606a61f4e568accd067253a6315d4108f804b151635a97e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a752a715ae4c3087c68e67b4f75ba6f9d4bc0bd62db404a1cb4ea6a3acdb5296"
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
class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.275.tar.gz"
  sha256 "e8d3fa23a4c13e0c84fa1b1720b3e9b0d317960cfa87bcf5aaf58ef6aea2decf"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "38f8960bc4780bc942cd32f81d3355c43281549bbd3592a7c919688c30e3a12f"
    sha256 cellar: :any,                 arm64_sequoia: "20f11989eac18470cdaa81c5dea092de4ad6ab7f1c671ad09907a70d38b6533e"
    sha256 cellar: :any,                 arm64_sonoma:  "46d7e3ac7dd8ea5aa0f537d0fcaa6b28a04cbece4bf6c9137ea3ed42191c21ed"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "73d2ed997ca0e9c29c6906c90402085ce92a0aecc427aa967bc4a5fcee0ec134"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "37b90cd5b5f6c40fdf0943710c3b5053dd5341ae206a422f252fe59f62a17ab4"
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
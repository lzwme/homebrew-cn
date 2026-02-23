class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.1178.tar.gz"
  sha256 "a98a419d29a2bea2e6139300089c65e98285b9ae72b97c9341b605b951b48e9d"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ca3fbc7943a1dc81ff0af275a29f8da0a5a2eda37d3caea8aa63c63ff462de46"
    sha256 cellar: :any,                 arm64_sequoia: "91072b522741749db71a0f240edb5e12b0eb8ce2765ef9c30f3460d701a6e636"
    sha256 cellar: :any,                 arm64_sonoma:  "78a9eec72439d7006b505c93fe7ecee95fba817312da7388833b34061050e1d7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b4da4841b501327e01c44b46b128b683a72a841b190ee509b3fae9432bbe7056"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b64d372a7b6184d701977f0eebd41a34238878b141a07e16e2500d356dca670"
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
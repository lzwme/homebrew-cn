class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.17.tar.gz"
  sha256 "234b88139202af9f8241493f7ef8756efe216cee2535146fcb8c79175473d07d"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "42b9e84399b2bca3124cc8cd8af0725acd09616db3cb9a2aa14792dd9e9c3228"
    sha256 cellar: :any,                 arm64_sequoia: "f81a21a5a9425d50d8a606848113fa72220a371807a00761377cce06e075603f"
    sha256 cellar: :any,                 arm64_sonoma:  "959d21cb7c5926d5215409fc757a3c606fd2cb928440fb40249c2bce017b31ed"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6bdad70085ffbdf880808aabbc4a04ac8f265ba336879a3a8067da54517d0cff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "588068561874b4a1247141d72041f78b49c550385f0ca6273719ce43f24919ab"
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
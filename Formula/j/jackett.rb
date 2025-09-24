class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.23.56.tar.gz"
  sha256 "b76abef4fd4d19a97222a2e0b75c730e2a933647f9f0d9c705174aec0402ba29"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1063ca5432f4d57f2b8df6a4c122d6c286230db6bf5f99b6d15d6304e318c72d"
    sha256 cellar: :any,                 arm64_sequoia: "df6816cc56d1e2d69275097fbb40212f0469de55d60fc998b662aec9cd678f1f"
    sha256 cellar: :any,                 arm64_sonoma:  "a8acf7bee4368048cd2b24484db91670e8dfb38a97260248a6dc2b06dcefaa38"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c2ab29e3f6d54d37bcd4e051f9336c3a4261b049a997a011cefdb40dfc5174bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aea88fe73935e355814047bdbe32bedadc0d2aadb86257dce40f72a2c1e41ffd"
  end

  depends_on "dotnet@8"

  def install
    ENV["DOTNET_CLI_TELEMETRY_OPTOUT"] = "1"
    ENV["DOTNET_SYSTEM_GLOBALIZATION_INVARIANT"] = "1"

    dotnet = Formula["dotnet@8"]

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
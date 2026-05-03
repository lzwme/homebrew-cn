class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.1813.tar.gz"
  sha256 "c534091e3e6bb3bdabdd5c7e8f2d7860addba0570db1998c0229b741d10253ce"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "861cecbce53a22c5edcc3abe11dbc24745da2234d71dee5d9761c1adfab17d37"
    sha256 cellar: :any,                 arm64_sequoia: "2fa6aa4734e023c0580bec41714ad5f196faf4aa48665a0778375541f58d7350"
    sha256 cellar: :any,                 arm64_sonoma:  "f09db5c515dd34af4cba5c2d856e3b84b2245ce2dc1c65a4882777976a8b3365"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6f70cbc5278e98ada006fd33340ad698664f79430e83504bbc4894b90c253755"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8faaac20699c8bb5e03d9aef7d01a9356ccd01ca349028442b706e39a8664002"
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
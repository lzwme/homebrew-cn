class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.22.2294.tar.gz"
  sha256 "cf5f500c0084c463386c8ec775b6f1fa45d008ab252cfa612fd6afe461223f22"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6222972e35354e6d754175b99c87b01cae0732caf4ff35627bc7c0afd59bc2ed"
    sha256 cellar: :any,                 arm64_sonoma:  "4e594ca44c7a1c02d8273b9e4d672d7234097e356b2112f5730d0fecff6e2950"
    sha256 cellar: :any,                 arm64_ventura: "b3f340f8ce67128d6f1a5bb3cdb10aa80aa61fac33ccbebb1dbab95e03d3db4d"
    sha256 cellar: :any,                 ventura:       "c44263c69371e0cc1aec707ce262630d6d6184c6454b4d1db0b80462259dc10c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d8d1296d77e17ab1eed7e09dbd3099d4d52f21fcdf2de29721d29361c7194c52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "502171e33332462b1bec4ff8571f173445e91b30330057e98967750b5ba11aa1"
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
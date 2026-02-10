class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.1074.tar.gz"
  sha256 "52f9c672d6e1b5b65bbafea5546ab2ec740b4ecae5c1e3e9c7d017ddedd0ffda"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2926a32b529bc52488df578044253ff67fa285062b9be0ebcf554449b6a3fb36"
    sha256 cellar: :any,                 arm64_sequoia: "cbd7ed3f6c85ed8a32c9859e42e0bfe2508256f675c00c9d3f82d7d6616ee42b"
    sha256 cellar: :any,                 arm64_sonoma:  "4ad91e2145e453f91365c963a62c087d121b0dc62ddd807918d0e04699912184"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1bd165fc592577ead640049559572b2dd1fcd3b6278bb8cde573286c31e94cc7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ba8233bc677f4d70cd0e5960437ef4504373ab5f10b9c09e965f8ada8150799"
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
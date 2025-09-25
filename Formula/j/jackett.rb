class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.23.59.tar.gz"
  sha256 "0574b5b95ff1937da3f45e79cbc2bb730d21063896c2f015171597e018f2a36c"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9751873e50af5023cd221913a1460bf3b3c2000d7999f93a456d660a2f7e1687"
    sha256 cellar: :any,                 arm64_sequoia: "932b9fd0a1bb986e57419a698f78404c9efd1ff8bf0826f3b34d43c16021ffb1"
    sha256 cellar: :any,                 arm64_sonoma:  "b4c5a7006335aeffe9325ac595179676bf4fd9ab0afccb4c4b167e5f733f4e35"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a4b024fc1dfc7af8059a3967dfbec0f3de7591b0fa9a08bb24675b1a9a0297e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "917e6dec7eb9bf6c263212714dccafcfc1f8b4d7d51f1fe3e54b49fe0c0973d6"
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
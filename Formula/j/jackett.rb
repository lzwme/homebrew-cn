class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.22.2429.tar.gz"
  sha256 "4b56e9000e874e0548fc8ea47c5f3be0d5ca5f9bc2329f6f9848d85bef627883"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5afb66005aa6b3f4486da4981661661530519951edb353e40f3f66dfdf317245"
    sha256 cellar: :any,                 arm64_sonoma:  "ea0326321bdbc409f7755b8d5e722de7c157cb92aaa9dff15e58c9762edce922"
    sha256 cellar: :any,                 arm64_ventura: "8a74be1a8984203c12383e5c440464f18df8e80fd68806c622e3a6a0546f9524"
    sha256 cellar: :any,                 ventura:       "91a67943f3ea89e51a47fc044157ca87980ec208517626e2eea364195d710c35"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "024c587d9d2ff4ef9b3f640541f560b9adbfe6da183cf575a8202ed00dc4fbb2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e58072aa2596955b7e46f3b501a8a84a0bbcf90c9f62af5ff1b8e777aac080ef"
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
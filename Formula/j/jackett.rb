class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.115.tar.gz"
  sha256 "4cb7bdca053f945fbbebacb2313da9d27939b628218e020e9cf8362b9f13c101"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0dbca0408e26ef213eaaedc1ccdb1eb076ec7e518de7b57d6f1c354ae5c4522e"
    sha256 cellar: :any,                 arm64_sequoia: "f4c5b2275dd88165c6c3a034530ae051f3cf84d0b0f2aa8f9a4c4ba74f1c5512"
    sha256 cellar: :any,                 arm64_sonoma:  "00f98b6146b6fc0e55b60a67a58a98cae812c1a9137bd2f00144758a2ddf4b46"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3061de4deaaf8c8fcaaf5be2e881f621fd64f0165c9e7a8147a82ebf9288ad1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c464edd269e2704afc700302c602862d0a5b8a997d926e13579f0513fef42e4e"
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
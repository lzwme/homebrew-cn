class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.22.2301.tar.gz"
  sha256 "b861253e2f8c051e35e3c05a2fb57ca696636b74f4648c44aa63bece979cfe2a"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6503ba2a4baec37ed80eb4ced58e45cf5a88c06e503a49fc48a7b6110530ee2a"
    sha256 cellar: :any,                 arm64_sonoma:  "fa6718e92ede7390eb7a7da56383215d1e0c78031f08a974aeecc34b87e2a540"
    sha256 cellar: :any,                 arm64_ventura: "2206eaaa2f2bd0d0c3f97c05c5e6998480e1bb322821c8ad835c840bb7b0cbab"
    sha256 cellar: :any,                 ventura:       "7463582133431b4934dc10c957ec4bde3edd2a77177c9f529feba2c9629b4d76"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8aaa178daccc183f1d70b90a77f1a46f89ed091ff86da8edc1adf536e0473ee2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea3f4eaf79f5c451f9c8752034536e827bcc2939fdc7dcb6997deaa1dd925608"
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
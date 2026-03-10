class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.1323.tar.gz"
  sha256 "9a8815bdac5ebd5ef1e253751b0de56ec075af028ab168d9368a11d386e5c912"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5da5c9918f1ae6ee8eeb2f30e6242c0296a5f9dfa3524ae272f673ae1d2eae3b"
    sha256 cellar: :any,                 arm64_sequoia: "78b37426a433c27a2f4e32f594b2697ee895867fa124ac14f92ae34837af614b"
    sha256 cellar: :any,                 arm64_sonoma:  "ea504c3b89aa4ea379b74e6d16da6104652b962ac8aa5ff26adce9ec83a2f65a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "da66cf19ed06c5fc6f37adfa91eda09aec2c2b6065786ed404c2a7e54f330241"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c44b6b96c57814a12ef5dd56b3fe059d9778c2dcbf0a42f61b37c34d70021579"
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
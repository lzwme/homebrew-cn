class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.2246.tar.gz"
  sha256 "8b079b913967c0d4ff1a46fba015abca3bc3aa4bccc0f2bf0d0173d25f1ffecd"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "49eb1eda56c5d34ead2cd268b7b53a63715a44b84a8be2b83490ed2f1e4e969d"
    sha256 cellar: :any, arm64_sequoia: "c91eebdb7faec242e9bbaf13700c371a12fa1b6c0b2bec69e7592c5e653b7ebf"
    sha256 cellar: :any, arm64_sonoma:  "c0a61a59d843ae4c6ed18a9e8856f0a84f224755f224c216e908cf2fb9bc8aa3"
    sha256 cellar: :any, sonoma:        "cd2461d419f4bc842115f12d61996ed10c713d8484f9e5000a8a9117b735a9b0"
    sha256 cellar: :any, arm64_linux:   "c2b117ed7d82d87afefe9a60efaa58c4028fc9b676b4c85c9d36dff7e253fbc3"
    sha256 cellar: :any, x86_64_linux:  "673ec9207eba6df4801e623e6bedaa652e526a5462532f305f962546571cb05c"
  end

  # Aligned to .NET dependency. Can remove if updated to latest .NET
  deprecate! date: "2026-11-10", because: "needs end-of-life .NET 9"
  disable! date: "2027-11-10", because: "needs end-of-life .NET 9"

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
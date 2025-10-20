class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.156.tar.gz"
  sha256 "8d76e269a1802b19d10ae3bb7a030d2579e007399e3ce2b67cecc7324bf90d28"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "987cb0cddcbaa394bbaf8b8cda147b661dd5ac4a4b93f5dc575dc96c9025032b"
    sha256 cellar: :any,                 arm64_sequoia: "6318d66e32a3e047682b32b1cd21abccff520ac304248e405310a68550782934"
    sha256 cellar: :any,                 arm64_sonoma:  "edc155d2456b61fc08ebd7bf375cb9b33e8aa83535add4fc391625c44fcb08b3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6cb3a7952f7158c2b8d1585f8607e8c7a53b99861a1c1f9fcabde86b2d4877a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ad179e789d85c7e10a2ca8af564f3b6179874e4aa24db05cea9818f99a93e3f"
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
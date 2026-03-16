class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.1375.tar.gz"
  sha256 "adff5a22bfb8ae64f85bfabf57a06a7a7847fe06ea65242f970c1778035a87d4"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5432bd6b20c9b3a978de68ce3bb4dcd86ccd6fd41dfa62c10f9ef218fa69c7a0"
    sha256 cellar: :any,                 arm64_sequoia: "dc732ab4e04617b8d6520ed1c8f6f8e655ee5bb72ee525471ae32ff369f892fd"
    sha256 cellar: :any,                 arm64_sonoma:  "913f4389e56ff3ba6be015c04d5448dd98920222f077f21d0305d34c14c536f4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ce84c2dfc0c1dfe3fdf5602446952672ce7289bc37b31412d8201c4ddd3de3b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "92bc3e809851b2422501e8e7b7d3821676e1f52e9195405d42433db1c29a8825"
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
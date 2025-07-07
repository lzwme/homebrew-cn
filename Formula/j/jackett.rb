class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.22.2123.tar.gz"
  sha256 "993cfad4a028037e3b51cbecf48e6362cb048d2d133fb55b94f3806b739a28f0"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "70abf64a6e6cb4d5d3fa4609f7b514c3ec6cd646a8644b252c339efd10b56aef"
    sha256 cellar: :any,                 arm64_sonoma:  "bb79fa298cf441b1117df7fbeb0e8a1351230d52d37013629aabb853aa7b55b3"
    sha256 cellar: :any,                 arm64_ventura: "11b7b99e36a52530816af64fe3b5cce95fc7085f262c7cb1223572ea2ee2f081"
    sha256 cellar: :any,                 ventura:       "fbc18171cac14faabb186cf94ef7e3dec05be7fb97583a7d4924ab1129e0e4ac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "894d2ad635f1c317fcad91144d9166ff3cdaee963d793928acb5790d807eea82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd19480997e84789179ff275f22e34ebd2c04b11cc000078d3fcab70968b69ef"
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
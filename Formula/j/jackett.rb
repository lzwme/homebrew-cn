class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.1302.tar.gz"
  sha256 "5389f9a41e6505afd88f97be6b590583bd0743bfb2c2cbd8e3c8d0aaacb01c5c"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d2ab1a4834cc8f373ea0e3adab299446a0fa2a3599f7cea4a75c342e91b61963"
    sha256 cellar: :any,                 arm64_monterey: "35d269fe259f6287b2e152c5ffa88c71778c6c9672327503f9cae8ec0c3772d1"
    sha256 cellar: :any,                 ventura:        "a9cb6a8a75562caf093e182a4e7130d16ecc0c8226c933af6cb92fbcc9374052"
    sha256 cellar: :any,                 monterey:       "f2c101321afc0f9e0c9510109ba96238c4ec13fa21b361763eeabd6c52ff0b05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c4a4d02d79672f72f68cf5c8315f46edd85604779c6ac365a5e1726edf86845"
  end

  depends_on "dotnet@6"

  def install
    dotnet = Formula["dotnet@6"]
    os = OS.mac? ? "osx" : OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s

    args = %W[
      --configuration Release
      --framework net#{dotnet.version.major_minor}
      --output #{libexec}
      --runtime #{os}-#{arch}
      --no-self-contained
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
      exec "#{bin}/jackett", "-d", testpath, "-p", port.to_s
    end

    begin
      sleep 10
      assert_match "<title>Jackett</title>", shell_output("curl -b cookiefile -c cookiefile -L --silent http://localhost:#{port}")
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end
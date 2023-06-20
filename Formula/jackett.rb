class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.258.tar.gz"
  sha256 "523e740d1088caea0d8c19f16402f77e1e0333d5e4b4b1ddc0d3715d9b20e9bc"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "fb1d7fe0a21e0f3e5551be66586df1586d423298517356c7189ba6d5686f95b1"
    sha256 cellar: :any,                 arm64_monterey: "b8a915f769f7095edf15c57293a14346373c2bcc701063bfb12f036c5ec5f976"
    sha256 cellar: :any,                 arm64_big_sur:  "7fbd26cbe157083a543b1ee1b15993c0e4c1f987df83690835fe46fda3e6261f"
    sha256 cellar: :any,                 ventura:        "9fd9c84b3ab132f1ce83f0f53ce1edd2a9d0e573091aff0478b625456408c523"
    sha256 cellar: :any,                 monterey:       "27780fe85ea8af2180dcdd6f933b7ab34ee56509791f7c75ca3da0626280cb65"
    sha256 cellar: :any,                 big_sur:        "b25ad174f1427ddade46a35ac664d45de7ae506c6001eaace15519bbabf33087"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "24438a58eeeecc9b2875f66a1e11bc455f6d8c171454dfde258e66595c3e3379"
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
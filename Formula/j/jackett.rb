class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.674.tar.gz"
  sha256 "38a6836f0db9a4bbb33dffb3b99b88cac321a906d2f55fe6aeb3d389b3124519"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "71521a605bc686ad3a9d2f356989777cc901d7d4e606d5f067d37f59359e04e8"
    sha256 cellar: :any,                 arm64_monterey: "a02de75e708baedf5ecd97d1a95055e1ec6dea07ee0b9c384aa3bf3996c5c9ff"
    sha256 cellar: :any,                 arm64_big_sur:  "4a4a553ee277b9330ae119b5bd85d5c7dcc464c9146123700cc69426107c99bf"
    sha256 cellar: :any,                 ventura:        "463f8516f927ac7710e5cdbd9c903896585676448b96a36e1bf396f08472c665"
    sha256 cellar: :any,                 monterey:       "90cc181c108ab4de9f015581d9cdd2c09d1326916b9a03c16c2be0e9d54c11e1"
    sha256 cellar: :any,                 big_sur:        "2968565529e0a2902445457b94ab9d0e78769b44615632a059de1c2df3d061c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e682803ed964975d2026087b1941e4c59c36fd8cb93295d98636f1d054cc6117"
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
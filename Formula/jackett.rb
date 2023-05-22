class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.4207.tar.gz"
  sha256 "b714a4c1372df5206e42df39fcf10f921820106aa982424533809194679720a9"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "1bcae9c295faa05714840f1b3610761603e7d8a7f8421de9631001585fdc9578"
    sha256 cellar: :any,                 arm64_monterey: "772cf26e5edcfeb2ae65e93bfbf9a1a019f06ea474be939099048477beea312e"
    sha256 cellar: :any,                 arm64_big_sur:  "5575edc0cc2448e27023713b76b1c89947143c24489b4b915cc23961c259e5ab"
    sha256 cellar: :any,                 ventura:        "977f856a0b46f8ea8b0d07187d38cd0a9badb0890da1afb939a5f3d0e6f36d56"
    sha256 cellar: :any,                 monterey:       "9937f013eeb69583ff9b8c97cfa85a7471f835eef28cce2d698db7d5bd07123d"
    sha256 cellar: :any,                 big_sur:        "e3a13e9c75c6836a95306af2e77fe0f03c8e51306c0f342961da630a41bbd596"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ef6cf7851c64a4cc3f7dd9c973ff312eaaa57ada62c3d5efbb04ffef2749befc"
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
class Btop < Formula
  desc "Resource monitor. C++ version and continuation of bashtop and bpytop"
  homepage "https:github.comaristocratosbtop"
  url "https:github.comaristocratosbtoparchiverefstagsv1.3.2.tar.gz"
  sha256 "331d18488b1dc7f06cfa12cff909230816a24c57790ba3e8224b117e3f0ae03e"
  license "Apache-2.0"
  head "https:github.comaristocratosbtop.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "78935622a12bea59cd6f81f7c2b0987da0aa1904d7961c0fc3a0d6876dcdd8e5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9dc1d1071b48ea6178362ad2d1b5dc50b112005171ed42b99ef991dcdda48a2d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aa313baa0ce516db654b7682901e8a18badf94f2a64b35b367e4b4138f8bed24"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5a3745fee0bdddb1f008ebfde8a8a722e12b414e6eb68f9eef3cbbc2dd3cb3e0"
    sha256 cellar: :any_skip_relocation, sonoma:         "071ec3e43c56f2620306abd0a251e28a498a8b2ebea7d2b69f51e308f4caeed2"
    sha256 cellar: :any_skip_relocation, ventura:        "c265f1a9168be1a6891df694a63b3dbf2f7e6355da11dae8f42d3e1783f0c9b2"
    sha256 cellar: :any_skip_relocation, monterey:       "06f5cdcfd5de146eb9b89b8331b2e0cd6fe0ace3e89e8b4b647878b8be5a8a62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "920fbd9f23f3cf29c1dde2c9fa36119d5429649a8012bfef9d34ca4c2a2f1a48"
  end

  on_macos do
    depends_on "coreutils" => :build
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1499
  end

  on_ventura do
    # Ventura seems to be missing the `source_location` header.
    depends_on "llvm" => :build
  end

  # -ftree-loop-vectorize -flto=12 -s
  # Needs Clang 16  Xcode 15+
  fails_with :clang do
    build 1499
    cause "Requires C++20 support"
  end

  fails_with :gcc do
    version "9"
    cause "requires GCC 10+"
  end

  def install
    ENV.llvm_clang if OS.mac? && (DevelopmentTools.clang_build_version <= 1499 || MacOS.version == :ventura)
    system "make", "CXX=#{ENV.cxx}", "STRIP=true"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    require "pty"
    require "ioconsole"

    config = (testpath".configbtop")
    mkdir config"themes"
    begin
      (config"btop.conf").write <<~EOS
        #? Config file for btop v. #{version}

        update_ms=2000
        log_level=DEBUG
      EOS

      r, w, pid = PTY.spawn(bin"btop")
      r.winsize = [80, 130]
      sleep 5
      w.write "q"
    rescue Errno::EIO
      # Apple silicon raises EIO
    end

    log = (config"btop.log").read
    # SMC is not available in VMs.
    log = log.lines.grep_v(ERROR:.* SMC ).join if Hardware::CPU.virtualized?
    assert_match "===> btop++ v.#{version}", log
    refute_match(ERROR:, log)
  ensure
    Process.kill("TERM", pid)
  end
end
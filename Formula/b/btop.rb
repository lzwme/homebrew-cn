class Btop < Formula
  desc "Resource monitor. C++ version and continuation of bashtop and bpytop"
  homepage "https:github.comaristocratosbtop"
  url "https:github.comaristocratosbtoparchiverefstagsv1.4.1.tar.gz"
  sha256 "40f6c54d1bc952c674b677d81dd25f55b61e9c004883c27950dc30780c86f381"
  license "Apache-2.0"
  head "https:github.comaristocratosbtop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b82735032693f6348979ecef71fe144b0ed4924196247f73b4473155c57e74f1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cdce095624f5619d43734c0c72804aeb435ea6f33e03b07d0375d1cc98f8f2c1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d31be5aa162325d62ca71acf9bcbe9a74891c206f091a9b7efd0535b20bed3e9"
    sha256 cellar: :any_skip_relocation, sonoma:        "a988fc1e48af05ae07ea846afd0ed6d094076db3e81e538967d8487dc8b5ed3d"
    sha256 cellar: :any_skip_relocation, ventura:       "1eacef16372d08705291b0aa20ce6185dfc2f2c05c1042e98734ac3fadd4a9a7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5c42e6890b4826de42e106930119736f23ee1d6af5e4d8ef3c27de624642a500"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb658947101f37b8f031761b3e9f27916b8e76925bd081e0c84da03f870bd4f6"
  end

  depends_on "lowdown" => :build

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
    # The build will silently skip the manpage if it can't be built,
    # so let's double-check that it was.
    assert_path_exists man1"btop.1"

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

    log = (testpath".localstatebtop.log").read
    # SMC is not available in VMs.
    log = log.lines.grep_v(ERROR:.* SMC ).join if Hardware::CPU.virtualized?
    assert_match "===> btop++ v.#{version}", log
    refute_match(ERROR:, log)
  ensure
    Process.kill("TERM", pid)
  end
end
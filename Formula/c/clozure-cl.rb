class ClozureCl < Formula
  desc "Common Lisp implementation with a long history"
  homepage "https://ccl.clozure.com"
  license "Apache-2.0"
  head "https://github.com/Clozure/ccl.git", branch: "master"

  stable do
    url "https://ghfast.top/https://github.com/Clozure/ccl/archive/refs/tags/v1.13.tar.gz"
    sha256 "bca7f8d70d49059f8937b82bc64f47f7d01c07dd18760002ec41b41c444f838c"

    # TODO: Remove in the next release
    depends_on arch: :x86_64
  end

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, sonoma:       "dbf1d6fa306b45dd024bcb4affa6ecdae29269e2de18b6d97c9ed0a7bba5eeea"
    sha256 cellar: :any_skip_relocation, ventura:      "77beee69a1b3748ed9f627c31b5ee91bd6914ee614e6b49fc027e1ab76f3ce86"
    sha256 cellar: :any_skip_relocation, monterey:     "df21345c80cded7b9d732d1158a904bd0fe8118bd91da58fe99d3614c02f1e1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "9d0f7c8987f103a1002a96a696df47d99765c6604ab91630121a0e1209c6afbb"
  end

  on_macos do
    # Can be undeprecated if upstream decides to support arm64 macOS
    # https://docs.brew.sh/Support-Tiers#future-macos-support
    # TODO: Make linux-only when removing macOS support
    deprecate! date: "2025-09-25", because: :unsupported
    disable! date: "2026-09-25", because: :unsupported
  end

  on_linux do
    depends_on "m4"
  end

  resource "bootstrap" do
    on_macos do
      on_arm do
        url "https://ghfast.top/https://github.com/Clozure/ccl/releases/download/v1.13-arm64-pre2/darwinarm64.tar.gz"
        sha256 "382426a718af3fa9ae15d682fb47d5921dda3565b1a087c3d34d9ff45f3b3bfe"
      end
      on_intel do
        url "https://ghfast.top/https://github.com/Clozure/ccl/releases/download/v1.13/darwinx86.tar.gz"
        sha256 "0eceab57e519f82bd6db011c596eb2a28e2a510abcd76e217d49a10e90f4002f"
      end
    end
    on_linux do
      on_arm do
        url "https://ghfast.top/https://github.com/Clozure/ccl/releases/download/v1.13-arm64-pre2/linuxarm64.tar.gz"
        sha256 "966a7182607e729e41e42159efea4618c2b305dc000e2b902ffe8aa7199ab449"
      end
      on_intel do
        url "https://ghfast.top/https://github.com/Clozure/ccl/releases/download/v1.13/linuxx86.tar.gz"
        sha256 "dd7dcb1631305cc7e32aef67caaa89662e05999dd30e72fbfa554a96f9473e13"
      end
    end
  end

  deny_network_access!

  def install
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x86" : Hardware::CPU.arch.to_s
    suffix = Hardware::CPU.bits.to_s if Hardware::CPU.intel?

    kernel_prefix = os[0] if !OS.linux? || !Hardware::CPU.arm?
    kernel = "#{kernel_prefix}#{arch}cl#{suffix}"
    kernel_build_dir = "#{os}#{arch}#{suffix}"
    interface_database_dir_prefix = os + "-" unless OS.linux?
    interface_database_dir = "#{interface_database_dir_prefix}#{arch}-headers#{suffix}"

    resource("bootstrap").stage do
      buildpath.install interface_database_dir, "#{kernel}.image"
    end

    system "make", "-C", "lisp-kernel/#{kernel_build_dir}", "clean"
    system "make", "-C", "lisp-kernel/#{kernel_build_dir}", "all"
    system "./#{kernel}", "--no-init", "--batch",
                          "--eval", "(ccl:rebuild-ccl :full t)",
                          "--eval", "(quit)"

    doc.install Dir["doc/*"]
    libexec.install Dir["*"]
    (bin/"ccl").write_env_script(libexec/kernel, CCL_DEFAULT_DIRECTORY: libexec)
    bin.install_symlink "ccl" => "ccl#{Hardware::CPU.bits}"
  end

  test do
    output = shell_output("#{bin}/ccl64 -n -e '(write-line (write-to-string (* 3 7)))' -e '(quit)'")
    assert_equal "21", output.strip
  end
end
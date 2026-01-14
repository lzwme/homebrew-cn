class Aptos < Formula
  desc "Layer 1 blockchain built to support fair access to decentralized assets for all"
  homepage "https://aptosfoundation.org/"
  url "https://ghfast.top/https://github.com/aptos-labs/aptos-core/archive/refs/tags/aptos-cli-v7.14.0.tar.gz"
  sha256 "c422582a8fd2a95dd728e0a43fd9fb3ac31f7948d2b3d1417b3eb6a73102fcb4"
  license "Apache-2.0"
  head "https://github.com/aptos-labs/aptos-core.git", branch: "main"

  livecheck do
    url :stable
    regex(/^aptos-cli[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f5842845bba1f5308e1a59e0436520e38b80012f1b0708e136ac85cf81dffd5e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "73fd31d979032b2d0124afc6dc5c482b455fbc9cf08507b86650926521f2db61"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "39ca5420fd9571c762ceb365eda06025f8fd0579a98a6db0deaf7804d330dd72"
    sha256 cellar: :any_skip_relocation, sonoma:        "8594337156c60a9accd346065499c1fd295ca4e6f1ea6d088604aaaf00599913"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d4f5d3027ba74c0a4f973d06ef54de81de78a74fd18e316b8dea75463172c947"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5577346377f43536bf7245cd7b5d4a4ae90fa553a664797c6f90c0b331bbdb91"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  uses_from_macos "llvm" => :build

  on_linux do
    depends_on "lld" => :build
    depends_on "pkgconf" => :build
    depends_on "zip" => :build
    depends_on "elfutils"
    depends_on "openssl@3"
    depends_on "systemd"
  end

  def install
    # Use correct compiler to prevent blst from enabling AVX support on macOS
    # upstream issue report, https://github.com/supranational/blst/issues/253
    ENV["CC"] = Formula["llvm"].opt_bin/"clang" if OS.mac?

    system "cargo", "install", *std_cargo_args(path: "crates/aptos"), "--profile=cli"
  end

  test do
    assert_match(/output.pub/i, shell_output("#{bin}/aptos key generate --output-file output"))
  end
end
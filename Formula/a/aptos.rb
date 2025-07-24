class Aptos < Formula
  desc "Layer 1 blockchain built to support fair access to decentralized assets for all"
  homepage "https://aptosfoundation.org/"
  url "https://ghfast.top/https://github.com/aptos-labs/aptos-core/archive/refs/tags/aptos-cli-v7.6.1.tar.gz"
  sha256 "1f89fe5eae42a48895b9fbad09b90731f4415f05187df135bf90a11682178b7d"
  license "Apache-2.0"
  head "https://github.com/aptos-labs/aptos-core.git", branch: "main"

  livecheck do
    url :stable
    regex(/^aptos-cli[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "80eb903797599d4512bad16e195152a210b1d3bfc94fedaa46f755ee4e216b39"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "27c82535187b8068f14533db638bb0e9e77d7790076c538e1465a65ed6b0e409"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "baeba94315113fed09e5799d552279486c143776081af8f433ee869668c2702b"
    sha256 cellar: :any_skip_relocation, sonoma:        "26a50d5786954918a860569d71f1b1f6b3b530cbc59793ec7fc99c3911a1cafa"
    sha256 cellar: :any_skip_relocation, ventura:       "be2e97b81dbc05582b69a148e9b2e1b41de2f32d766b7caf556f3cb891f73a31"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "955969669a2295afcefc3f84ffbec98ccb657b5965c69d5401683f00b2e4479b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46b4ad714561520d78d2208f8a02201cf33c8fc01e0d6a4a9678d78c39ad4bc9"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  uses_from_macos "llvm" => :build

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "zip" => :build
    depends_on "elfutils"
    depends_on "openssl@3"
    depends_on "systemd"
  end

  def install
    # FIXME: Look into a different way to specify extra RUSTFLAGS in superenv as they override .cargo/config.toml
    # Ref: https://github.com/Homebrew/brew/blob/master/Library/Homebrew/extend/ENV/super.rb#L65
    ENV.append "RUSTFLAGS", "--cfg tokio_unstable -C force-frame-pointers=yes -C force-unwind-tables=yes"

    # Use correct compiler to prevent blst from enabling AVX support on macOS
    # upstream issue report, https://github.com/supranational/blst/issues/253
    ENV["CC"] = Formula["llvm"].opt_bin/"clang" if OS.mac?

    system "cargo", "install", *std_cargo_args(path: "crates/aptos"), "--profile=cli"
  end

  test do
    assert_match(/output.pub/i, shell_output("#{bin}/aptos key generate --output-file output"))
  end
end
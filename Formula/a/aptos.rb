class Aptos < Formula
  desc "Layer 1 blockchain built to support fair access to decentralized assets for all"
  homepage "https://aptosfoundation.org/"
  url "https://ghfast.top/https://github.com/aptos-labs/aptos-core/archive/refs/tags/aptos-cli-v7.13.0.tar.gz"
  sha256 "3630993c97ad776d88cd87440fd9094b7633acadca138324f882302250d8403d"
  license "Apache-2.0"
  head "https://github.com/aptos-labs/aptos-core.git", branch: "main"

  livecheck do
    url :stable
    regex(/^aptos-cli[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "97ca4081ee4d0bf5dd2abec4c86cf54ed58d473e6c022c4ee49f109ba1d84136"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7134c8dba310d8f5a0ba89249f7118b4d76668c959a648d212e41f4ee062da2e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cf956284cb406034d2a1c3a0336e80b064eeed72ca7fde28eeb611a66a81c1d2"
    sha256 cellar: :any_skip_relocation, sonoma:        "1a180e582a8df138f37ae11be88542f706cb6b76667e5cef9b5c3be8d0f9acbd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aa9de038c3f7a7e64b0e2aa7218f7fddf97b7e0f0695a888758aa55545699bc7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "91446e1efd49969f0e2f374908e4932cfd1a05779268521793664c30c6455bde"
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
class Aptos < Formula
  desc "Layer 1 blockchain built to support fair access to decentralized assets for all"
  homepage "https:aptosfoundation.org"
  url "https:github.comaptos-labsaptos-corearchiverefstagsaptos-cli-v4.3.0.tar.gz"
  sha256 "5ff9a9c0920cfc47ace639306a3d12c64f809d3fb83e3a9e64728a31917bbb1d"
  license "Apache-2.0"
  head "https:github.comaptos-labsaptos-core.git", branch: "main"

  livecheck do
    url :stable
    regex(^aptos-cli[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ee7fd1a297e94af98b42622fd6714f8a08f3ad613f207c1d95ee3f1961d7a694"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "244f820cd84dff8986f3abb9e3b2bd2c53407f86485a5037e8f8a7d18957a489"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f0f3f33ba38db2afa902fb3155f6047eb80a4acb4f1dc97c65f13d2a65ff215a"
    sha256 cellar: :any_skip_relocation, sonoma:        "a606435e042953046a7055023591c6e89dd681afccdc76958745e6c0320aaa17"
    sha256 cellar: :any_skip_relocation, ventura:       "877f7bb11afd47de49c6c7841b9f263889e0e0b8c562faa05de620a34337adda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b81249c70d2f7eb2fc6e9089e2afc5f84c9860d239597f2809ca0ba7232b6577"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  uses_from_macos "llvm" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "zip" => :build
    depends_on "openssl@3"
    depends_on "systemd"
  end

  # rust 1.80.0 build patch, upstream pr ref, https:github.comaptos-labsaptos-corepull14272
  patch do
    url "https:github.comaptos-labsaptos-corecommit72b9657316c699cfbef75216f578a0bd99e0be46.patch?full_index=1"
    sha256 "f93b4f8b0a61d245e13d6776834cec9ecdd3b0103d53b43dcc79cda3e3f787ed"
  end

  def install
    # FIXME: Look into a different way to specify extra RUSTFLAGS in superenv as they override .cargoconfig.toml
    # Ref: https:github.comHomebrewbrewblobmasterLibraryHomebrewextendENVsuper.rb#L65
    ENV.append "RUSTFLAGS", "--cfg tokio_unstable -C force-frame-pointers=yes -C force-unwind-tables=yes"
    system "cargo", "install", *std_cargo_args(path: "cratesaptos"), "--profile=cli"
  end

  test do
    assert_match(output.pubi, shell_output("#{bin}aptos key generate --output-file output"))
  end
end
class Aptos < Formula
  desc "Layer 1 blockchain built to support fair access to decentralized assets for all"
  homepage "https:aptosfoundation.org"
  url "https:github.comaptos-labsaptos-corearchiverefstagsaptos-cli-v4.6.0.tar.gz"
  sha256 "a34897e4bdd70aa9b2d2678c087ed461118768af2ca6a1fd0e91f27f5600d5f2"
  license "Apache-2.0"
  head "https:github.comaptos-labsaptos-core.git", branch: "main"

  livecheck do
    url :stable
    regex(^aptos-cli[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9437d4aa22bc66a37282b222503433d50a99332a69758ebf3c2cae9d13211343"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b21aebbe7b630986802880a01d3a27757e7cb06047ddd782729470a1f68d1f3a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "914d1a91829011679769937dbf56338b5c606da60056e1185af8e85f2d85921d"
    sha256 cellar: :any_skip_relocation, sonoma:        "bf759fbf4a5b4ea514c37cd5dca6de88407eadc0ae95b7fd299b809eca152714"
    sha256 cellar: :any_skip_relocation, ventura:       "2c85d1afd10c291898a87b6f660b98282d0bc6d8326910c011ae4749abf5ac7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "92468ec8662d09040ec13b2920055012ba587cfeae94e6552bc13d0b87dfe6c1"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  uses_from_macos "llvm" => :build

  on_linux do
    depends_on "pkgconf" => :build
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
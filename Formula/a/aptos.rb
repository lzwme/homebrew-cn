class Aptos < Formula
  desc "Layer 1 blockchain built to support fair access to decentralized assets for all"
  homepage "https:aptosfoundation.org"
  url "https:github.comaptos-labsaptos-corearchiverefstagsaptos-cli-v6.0.0.tar.gz"
  sha256 "dda490c11aff83a8909cac18c9598de4d6b7e03dd72c34b76346022450da644c"
  license "Apache-2.0"
  head "https:github.comaptos-labsaptos-core.git", branch: "main"

  livecheck do
    url :stable
    regex(^aptos-cli[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9e77175f7e90d69d5aeba965ca9e22ea9a5d48c8b1f63ac24846540fc63995a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "25691262b844acc0555914780a5bdca0520bd81f8514fd01dc86f10a9245ba6f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2991b604a83362e99ec3e0156026a8fc30cbe83f23b0c22c363221a17aee833e"
    sha256 cellar: :any_skip_relocation, sonoma:        "ee4985aaa3fb639e866e66ccaf12523289fd5eda57d124380431a60c574a063f"
    sha256 cellar: :any_skip_relocation, ventura:       "1e7e89bc13a7063d77b5360f520cf1ab78c2be1e13b54d8a73cb4bfe6d574904"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fbdca5dd6fbfadeaf4455cffc299b62a09d62be183b6ffbe8457a20b3bd9306b"
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
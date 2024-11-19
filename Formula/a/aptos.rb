class Aptos < Formula
  desc "Layer 1 blockchain built to support fair access to decentralized assets for all"
  homepage "https:aptosfoundation.org"
  url "https:github.comaptos-labsaptos-corearchiverefstagsaptos-cli-v4.4.0.tar.gz"
  sha256 "04d0e6e21face1128b5cbe6d12165da39f50c8add0b39de331f9b90ed3e41175"
  license "Apache-2.0"
  head "https:github.comaptos-labsaptos-core.git", branch: "main"

  livecheck do
    url :stable
    regex(^aptos-cli[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dc1dc6eec559fe934152dfb35eb5666429078b9e60ff6f446e8e900d6d79446c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bf578c8008cad9762528b1e1fa3b2ded3b46112237e19283099ea0547d9121e4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "560d2b31a1b63ff12d58b7ed80089c5ea988fe3bb2cd6231e30b3dc06baaa5b8"
    sha256 cellar: :any_skip_relocation, sonoma:        "f15667c8f4587035ce8ed601c0e76c7b1ff065c4d1d50113c969f02c6b55f987"
    sha256 cellar: :any_skip_relocation, ventura:       "ab37ef0bb53f05cb041b4de086f3ad7964b36c945fe6f651122edacdf295311c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b49f22a139906c84ab14f568fd7799c63354141fccff742d343b8f036ea2062"
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
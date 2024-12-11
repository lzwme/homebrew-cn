class Aptos < Formula
  desc "Layer 1 blockchain built to support fair access to decentralized assets for all"
  homepage "https:aptosfoundation.org"
  url "https:github.comaptos-labsaptos-corearchiverefstagsaptos-cli-v4.7.0.tar.gz"
  sha256 "46e3568371030726cbaec17143be3a7c4eec016b6c5e249225500bc5d12b646e"
  license "Apache-2.0"
  head "https:github.comaptos-labsaptos-core.git", branch: "main"

  livecheck do
    url :stable
    regex(^aptos-cli[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b6edaf9b19a50349bd2813d0f5c1b4abee0386f3a2b307ee35643f548492e4b2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6d906a8757382c108a1510b1313e76124508e19c316a3a8cd97e924fb90c226f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "83fb63fad255e2ecc15b935b837f32bfafc188b24c9aef011434ad4c49135160"
    sha256 cellar: :any_skip_relocation, sonoma:        "c1e4c56ad68eee11c7b04c643a959a0eade79f40cd140b3b6f3bcca031c3be46"
    sha256 cellar: :any_skip_relocation, ventura:       "8caa5a517cf003d9d06515977b163f0629bf7e53bf278ca08a8f3fdd5be3bebb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "067ee06efaff4379c1164200317ba191ee6272ff74b2e418d6aa4ff61faaa2b4"
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
class Aptos < Formula
  desc "Layer 1 blockchain built to support fair access to decentralized assets for all"
  homepage "https:aptosfoundation.org"
  url "https:github.comaptos-labsaptos-corearchiverefstagsaptos-cli-v5.1.0.tar.gz"
  sha256 "25bf75904803c590f59e351e832f91a67f54bd09a1dd2c248edfe21a9b977c1f"
  license "Apache-2.0"
  head "https:github.comaptos-labsaptos-core.git", branch: "main"

  livecheck do
    url :stable
    regex(^aptos-cli[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aee1aeb80e5a35beecd7f4a4e09a792adb0d2110fbe0ea93e21f11e5804eed47"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "83c2a900840d183989e30f733eb06d538c790cb48e9e05d8dd61a3d62faea550"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "78750227021e77fe12464fd15521edc9af568c4c2c2e7899780b83c777df40d7"
    sha256 cellar: :any_skip_relocation, sonoma:        "2a2761bb5c291805303546229291c1192ea6f3b4fad2604cd45612567867f052"
    sha256 cellar: :any_skip_relocation, ventura:       "166ccf8b55ce4a74ef88c72760194f00fe0d89d64e4e057fe566b2e3e11afbf4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2a4ef7f9ff39649940b9f6147eeaaf9d62544d245d82974d4825e514a583cd36"
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
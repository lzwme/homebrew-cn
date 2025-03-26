class Aptos < Formula
  desc "Layer 1 blockchain built to support fair access to decentralized assets for all"
  homepage "https:aptosfoundation.org"
  url "https:github.comaptos-labsaptos-corearchiverefstagsaptos-cli-v7.0.0.tar.gz"
  sha256 "3fa6875f34e587f049719b2cd9cf3e8be25aec812efa43ba7e7042a3948cf8ac"
  license "Apache-2.0"
  head "https:github.comaptos-labsaptos-core.git", branch: "main"

  livecheck do
    url :stable
    regex(^aptos-cli[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d6614b83d4e428b601124c3cfeab6a1a6c7ec0c6107100a4f2316a26ebd71de7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f3c26943aaba95d282ecc80b36c40565e2caf1b6ed1a5d60f7bb99c6977d6b5b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "24d5c338c95bd4254b752bffdd7c334546e1095e8251ad9b18ae932ac3faa261"
    sha256 cellar: :any_skip_relocation, sonoma:        "ff5b7f318516c8232f6a4be002572d6af0f615fe8d5445e54bf32bb87349ba75"
    sha256 cellar: :any_skip_relocation, ventura:       "f57b138504693a38f0483835ec3776555921b2e2e2414e8e9cbd098305c06faa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b13eb84488b8022251c012c96df1bed82608d8b9fdaa9b38e38afee2007fb3cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c4ea1a8ecb381c7dd9e7c49ff6dc99f3484d25d980d1b27c612947f93fd2738a"
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
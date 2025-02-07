class Aptos < Formula
  desc "Layer 1 blockchain built to support fair access to decentralized assets for all"
  homepage "https:aptosfoundation.org"
  url "https:github.comaptos-labsaptos-corearchiverefstagsaptos-cli-v6.1.1.tar.gz"
  sha256 "f9d951ac989a91f4af499c64359db1a51466a001448454a1c4d01f5d0c0c9b8f"
  license "Apache-2.0"
  head "https:github.comaptos-labsaptos-core.git", branch: "main"

  livecheck do
    url :stable
    regex(^aptos-cli[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0c3bee895237ed4273b6709e0f22e60ea747d082ca23511f72fcf1db5e03e296"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a36572f08618e3e425b683fec2b6cedf717d2cb9a5165ca97106a34e5976f937"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e9ab2138cd9e9ce224c8b39e0bc7430969bd762985cf18bde50540a463275f35"
    sha256 cellar: :any_skip_relocation, sonoma:        "3c7b699fedaab41f11116632b289e07a81d53e99e1dd02190797b9ff8da1900f"
    sha256 cellar: :any_skip_relocation, ventura:       "092a177d997e317e088b9f849a0e4b12247af993bcf097709c696821a81ca901"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5452be8015d69ab621dc34ab8eabb6701f3d19d04a66731e252faf96d4ae2857"
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
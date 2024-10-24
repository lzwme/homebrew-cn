class Aptos < Formula
  desc "Layer 1 blockchain built to support fair access to decentralized assets for all"
  homepage "https:aptosfoundation.org"
  url "https:github.comaptos-labsaptos-corearchiverefstagsaptos-cli-v4.2.6.tar.gz"
  sha256 "422ad0c61ac1ca8dd52b093d1e372f08a070c6f9f141b4fe716fd3f1ae106a02"
  license "Apache-2.0"
  head "https:github.comaptos-labsaptos-core.git", branch: "main"

  livecheck do
    url :stable
    regex(^aptos-cli[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4571f288810289bd9c4417d0a5893593909db10fab332976bd7a93044040cf6d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5014028e10044d83aafa481bb77f5f992af73ae12cc49d526ec72690fbcf0945"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b54d61406286a60361d418d219e88672579d78c0f5b3f32725d6d36a7f34e5b8"
    sha256 cellar: :any_skip_relocation, sonoma:        "a4e91b462d814fa2f1a48d575a8f84c04965030aa8691e07d7d7b723d941b88b"
    sha256 cellar: :any_skip_relocation, ventura:       "7050e6a4d5cb8d50ec238a4c7b3f2ca886541354aa4e6193d41957db9272c0fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b3dbeba991b224aaa081083f22db1838539cff509d71c97173e5c63eefd4c485"
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
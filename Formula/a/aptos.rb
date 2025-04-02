class Aptos < Formula
  desc "Layer 1 blockchain built to support fair access to decentralized assets for all"
  homepage "https:aptosfoundation.org"
  url "https:github.comaptos-labsaptos-corearchiverefstagsaptos-cli-v7.1.0.tar.gz"
  sha256 "1f7d353bbfc6643b779863dffcef5396c35f2fbac677cffb7a9c29c126cb27a1"
  license "Apache-2.0"
  head "https:github.comaptos-labsaptos-core.git", branch: "main"

  livecheck do
    url :stable
    regex(^aptos-cli[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b58ff7cf0b81059c3cab2f0975877286dd57bd0aa819b76b1f5c3c5678ba8429"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "51ceffa391d3233297595b72781da0002d75303b8fbb25bfa5bb27a4d5944097"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1c7b57f18320f004ea390d8086da6df9d470d716f063a4db4ea0f28ed74d7553"
    sha256 cellar: :any_skip_relocation, sonoma:        "14cd025e56fc3cea1c29479b0c1bc12fd406fa44d7731a6c36c5a0914a109bad"
    sha256 cellar: :any_skip_relocation, ventura:       "871011060f9e6fb02a3bddd9e57b00f799badb1da9c94e15c355356f5c910c45"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7d96b813574a40e1337b43c1668dea0df4984d1f08aa6a811f6408f9bcd65e98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "12d8a662340e4d229a1c9508af19791a56f075a310ffc6982d7e3d43e8c79f5d"
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
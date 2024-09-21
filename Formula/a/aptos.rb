class Aptos < Formula
  desc "Layer 1 blockchain built to support fair access to decentralized assets for all"
  homepage "https:aptosfoundation.org"
  url "https:github.comaptos-labsaptos-corearchiverefstagsaptos-cli-v4.2.2.tar.gz"
  sha256 "c0a845cbbc4bd43d556db599ba0ad65cf98f835f2593491e1d85db42682597f3"
  license "Apache-2.0"
  head "https:github.comaptos-labsaptos-core.git", branch: "main"

  livecheck do
    url :stable
    regex(^aptos-cli[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "34a3e4997abd60172fe213f65ffa0fcee8f00df921ada7ea07aeb4d2de32b13c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "630fee62cd288dce870873fba7376e057e4a49b6c06379105b685fb3c20efffc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "634680f145c1c4fd62a1fabb46aae7d42944b21f004d4f3aa2affabe46970459"
    sha256 cellar: :any_skip_relocation, sonoma:        "98a354b8ba6faef706e8db6207a941d28258c0daa23b97cf12b7af342e0b3b30"
    sha256 cellar: :any_skip_relocation, ventura:       "81a6ea50e541bd7f0fc97fbe49ba72edd9664590331b9fba80a83a39fb352874"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f2ad14b66dd889e278df704d7abe181f07d37637a5fed8fa1a1b2f44b75ed21e"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build
  depends_on "rustfmt" => :build
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
    # FIXME: Figure out why cargo doesn't respect .cargoconfig.toml's rustflags
    ENV["RUSTFLAGS"] = "--cfg tokio_unstable -C force-frame-pointers=yes -C force-unwind-tables=yes"
    system "cargo", "install", *std_cargo_args(path: "cratesaptos"), "--profile=cli"
  end

  test do
    assert_match(output.pubi, shell_output("#{bin}aptos key generate --output-file output"))
  end
end
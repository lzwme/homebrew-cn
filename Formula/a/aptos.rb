class Aptos < Formula
  desc "Layer 1 blockchain built to support fair access to decentralized assets for all"
  homepage "https:aptosfoundation.org"
  url "https:github.comaptos-labsaptos-corearchiverefstagsaptos-cli-v7.4.0.tar.gz"
  sha256 "25e974b59570fef814be21895510f758b112adf2173621658c651898b9d1f979"
  license "Apache-2.0"
  head "https:github.comaptos-labsaptos-core.git", branch: "main"

  livecheck do
    url :stable
    regex(^aptos-cli[._-]v?(\d+(?:\.\d+)+)$i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5fafb67f3324d0187f42d3cefcf2e340a244129ad4577650cc44201a302085f1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7e7cbc4373ccb567b9dbfeeb6ce074338b8f255424156ec51c0a8dbd84d08628"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "44e5bf11b325a1cabcd71adf103c47fab631452a9be52ab4d6283daa35e130b3"
    sha256 cellar: :any_skip_relocation, sonoma:        "49bc2b22c5f3169d48bac756d1d829eaa444a43c075bc3221895106389219c24"
    sha256 cellar: :any_skip_relocation, ventura:       "42f8e97571137fc0c00a106edab57cdb303d890eb8862d07333b73f3b27c0daf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6b882c12b312d6daf20d239201e8dedc2fbb937c301e3df59465158e367aabf1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "79ec82cb2baf1e9e99136540583032b8fd3007e4dd04087375c736ecde913cd8"
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

  def install
    # FIXME: Look into a different way to specify extra RUSTFLAGS in superenv as they override .cargoconfig.toml
    # Ref: https:github.comHomebrewbrewblobmasterLibraryHomebrewextendENVsuper.rb#L65
    ENV.append "RUSTFLAGS", "--cfg tokio_unstable -C force-frame-pointers=yes -C force-unwind-tables=yes"

    # Use correct compiler to prevent blst from enabling AVX support on macOS
    # upstream issue report, https:github.comsupranationalblstissues253
    ENV["CC"] = Formula["llvm"].opt_bin"clang" if OS.mac?

    system "cargo", "install", *std_cargo_args(path: "cratesaptos"), "--profile=cli"
  end

  test do
    assert_match(output.pubi, shell_output("#{bin}aptos key generate --output-file output"))
  end
end
class Solana < Formula
  desc "Web-Scale Blockchain for decentralized apps and marketplaces"
  homepage "https:solana.com"
  url "https:github.comsolana-labssolanaarchiverefstagsv1.16.25.tar.gz"
  sha256 "1484cee30d86c65432da7f7ddc149938cad5b8c32f62ee71331b816d3d8d7700"
  license "Apache-2.0"
  version_scheme 1

  # This formula tracks the stable channel but the "latest" release on GitHub
  # varies between Mainnet and Testnet releases. This only returns versions
  # from releases with "Mainnet" in the title (e.g. "Mainnet - v1.2.3").
  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
    strategy :github_releases do |json, regex|
      json.map do |release|
        next if release["draft"] || release["prerelease"]
        next unless release["name"]&.downcase&.include?("mainnet")

        match = release["tag_name"]&.match(regex)
        next if match.blank?

        match[1]
      end
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8fc18a802ade5443e39a8f9e468edb4415fcd7c6d0b940a70a9511a92b160c17"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bc1eb972c27b48b58e3538e29f351629b28d67de8fd91a5ada7dea57aa86a5f0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9d3bd8d0a428862c7dae47dfe08298579761cb62b77834b18b63e328764482d1"
    sha256 cellar: :any_skip_relocation, sonoma:         "127acbdf3e0b46383f63a735a456da3dd9601ffc687a4743356c734ffbdda981"
    sha256 cellar: :any_skip_relocation, ventura:        "e639cefa15e6717c9b653038996b5b6a802c0d3f73a4ee0200554e6c5e77a1a0"
    sha256 cellar: :any_skip_relocation, monterey:       "c607e697dbd7e38cbe58215bb4aa2e073337963c1941f0bab4b231c82badb1bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9adab1221d52d7cb8f52618822abd652e016d2991a35cd5096797050c0b228ab"
  end

  depends_on "protobuf" => :build
  depends_on "rust" => :build

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "systemd"
  end

  # Backport part of upstream commit to build with newer Rust.
  # Ref: https:github.comsolana-labssolanacommit9e703f85de4184f577f22a1c72a0d33612f2feb1
  patch :DATA

  def install
    %w[
      cli
      bench-streamer
      faucet
      keygen
      log-analyzer
      net-shaper
      stake-accounts
      tokens
      watchtower
    ].each do |bin|
      system "cargo", "install", "--no-default-features", *std_cargo_args(path: bin)
    end
  end

  test do
    assert_match "Generating a new keypair",
      shell_output("#{bin}solana-keygen new --no-bip39-passphrase --no-outfile")
    assert_match version.to_s, shell_output("#{bin}solana-keygen --version")
  end
end

__END__
diff --git asdkprogramsrcaccount_info.rs bsdkprogramsrcaccount_info.rs
index 372370d0e15a0f2877b02ad29586e5b352438b24..3db3e9839b6535786e60be5602c03d0c909bf937 100644
--- asdkprogramsrcaccount_info.rs
+++ bsdkprogramsrcaccount_info.rs
@@ -182,6 +182,7 @@ impl<'a> AccountInfo<'a> {
         Ok(())
     }
 
+    #[rustversion::attr(since(1.72), allow(invalid_reference_casting))]
     pub fn assign(&self, new_owner: &Pubkey) {
          Set the non-mut owner field
         unsafe {
class Solana < Formula
  desc "Web-Scale Blockchain for decentralized apps and marketplaces"
  homepage "https:solana.com"
  url "https:github.comsolana-labssolanaarchiverefstagsv1.16.23.tar.gz"
  sha256 "50478a2ebe58153ca04e65ee41735b1a0810edd27eb5de7ee079af29f59c5141"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ee107aba4097b042c139266a46cf7029b7f5b68322242eea162f349133ad9475"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8d6448cb243e1747bb59e4084e9ca168a5ae68cd77b84a75985bf6a0a2540171"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "714e18600f12da5a7ebdb725642310e9738affd0df7a0353a7ea19df124216e0"
    sha256 cellar: :any_skip_relocation, sonoma:         "3ad10e4a5774c8bdadc45f8dddb76b26f9ecf74d8c69193dceed54a220092716"
    sha256 cellar: :any_skip_relocation, ventura:        "991d875ce95b05ee31879284beb753c74fef0bbc6e4a9c21ebde9b4ac045fdad"
    sha256 cellar: :any_skip_relocation, monterey:       "64a166a765c1c2344b0d0bb7471001ddc5cc8f5df8d3d7788399a82c4760903a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c0c7273370a6c136909d02655c7434914c23686db703ddb5db2c0f1f6a44833a"
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
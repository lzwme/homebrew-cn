class Solana < Formula
  desc "Web-Scale Blockchain for decentralized apps and marketplaces"
  homepage "https:solana.com"
  url "https:github.comsolana-labssolanaarchiverefstagsv1.16.26.tar.gz"
  sha256 "11609d4b1e1e46aa70733b4ec598bf246f99f5caedebff25cb7e666124f8d9d8"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "80407dd11145c479eb17bb254e2e6ff522fe71c98018bdec036546ba6b144396"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "917ccefe5f76a392a0598a56bcd3c44be7aabf64f2a80f5f27b29393e052be70"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6cba64ad51906effc40d1011afd48f9f9bbd2255d0c27c85eaa68b2665b5573e"
    sha256 cellar: :any_skip_relocation, sonoma:         "9adcf2c31818cbc929d97b7c50079a253655cc69970e9e7a83ca33e215b67918"
    sha256 cellar: :any_skip_relocation, ventura:        "c9bc37284faeae3de841b0699d9b4fecfbe47dc0c4dc672c3732d1b2bf482eb1"
    sha256 cellar: :any_skip_relocation, monterey:       "84c8c0b9c8ec3a41e1220d398b8ec33db8d1ad4250da6f4a60ff3e773d0c537e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0219d9add4b78f300217fbdade811c86a805ef13bbd34b5f61b14ea1955b5d01"
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
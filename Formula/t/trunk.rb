class Trunk < Formula
  desc "Build, bundle & ship your Rust WASM application to the web"
  homepage "https:trunkrs.dev"
  url "https:github.comtrunk-rstrunkarchiverefstagsv0.20.0.tar.gz"
  sha256 "83e5cf0760d08d78e93ab3aefdcd55ccd2a6fd681742a2ebc2602659b55e94cc"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comtrunk-rstrunk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "97467f46058848b5bd2c90720db1d1bbfafcd2d6ba9bb660b724e024898d0b5f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8da66f1507889653efdd48dc3c72ef0f867b5f6e406a20db458e487d8346c17a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8e77eb0a8db19a6c7737af68a1d10b5628e25d4d5bc7e5af13205821cd6582a0"
    sha256 cellar: :any_skip_relocation, sonoma:         "dd39fb27c0c022edf6af80c77e4ce28e22a64a806d14b536de64ad527e003110"
    sha256 cellar: :any_skip_relocation, ventura:        "8e5faee1c751a7c550be45b4be96d5d4fbb54bba988eee97db455192e1c01551"
    sha256 cellar: :any_skip_relocation, monterey:       "e5b08178bc74d6dd71ada3c082b4aec7730221348bd16c9e5926787c3f3766e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2c4240cc94498e0680454d1731e931e2e582ff7e7e353c9c1f782c9a7168d36e"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "ConfigOpts {\n", shell_output("#{bin}trunk config show")
  end
end
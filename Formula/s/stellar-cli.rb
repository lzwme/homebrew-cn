class StellarCli < Formula
  desc "Stellar command-line tool for interacting with the Stellar network"
  homepage "https:developers.stellar.org"
  url "https:github.comstellarstellar-cliarchiverefstagsv22.8.0.tar.gz"
  sha256 "08b634e25e4c7870936a83c2bf8fed451a4a4bcbdd06b5dc0b7b87818c0ce41b"
  license "Apache-2.0"
  head "https:github.comstellarstellar-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "53d792d9bf9b480a746afa78a8f6a8a339855204583361303607a3e941acc37a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e9aeb570b1afc8cb6fc053883da2fb7645e7c8f7959af65d7d1cf8116e168951"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f62fa20e0ea352c56359c76ff1614567dbedd24e953401efb751860d4c149b3f"
    sha256 cellar: :any_skip_relocation, sonoma:        "7082f6f130da5443172a1df8e59641fd92e7e7f007f0fed19aa22f39e23425eb"
    sha256 cellar: :any_skip_relocation, ventura:       "2d31abb1759b2fee92a0f1c036bcc8efb6dfbf4ffa8f4112d7c267a953fdafd7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bf90b960bde76e8a59b8acef5f3a074eba7d717ee23d992155934a14b7bf99fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e863c8a28c6a812ee3632a273c1bf6fe8bf8adcc82e2d8cb8e91c26e602f0f0d"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "dbus"
    depends_on "systemd" # for libudev
  end

  def install
    system "cargo", "install", "--bin=stellar", "--features=opt", *std_cargo_args(path: "cmdstellar-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}stellar version")
    assert_match "TransactionEnvelope", shell_output("#{bin}stellar xdr types list")
  end
end
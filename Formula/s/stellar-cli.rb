class StellarCli < Formula
  desc "Stellar command-line tool for interacting with the Stellar network"
  homepage "https:developers.stellar.org"
  url "https:github.comstellarstellar-cliarchiverefstagsv21.4.1.tar.gz"
  sha256 "3e6c6e0162b96fc0098f2f2c9d8db48bcc18f638fb7eb82e20b09ca7579afc23"
  license "Apache-2.0"
  head "https:github.comstellarstellar-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "238b2a02315603eb4be4b4632b74542a13a4d9c687cd7932993df07d7e0d44f2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b93e6d98d550a8114f19b036199c0fd95548283789d8f2233f553a13d68a0c9d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "50461eec1c0b6bfdb8ddd81e9916bd3c7fded28b36dd12bea3edcba6b6508518"
    sha256 cellar: :any_skip_relocation, sonoma:         "92d953d9ea710dcfe876404fc87b72634b9f2e5778095d84b2eea776f753347a"
    sha256 cellar: :any_skip_relocation, ventura:        "8488c0af3e3c8a86819e2f7110c75c790554418c66f35bd308f43c18478a3bb3"
    sha256 cellar: :any_skip_relocation, monterey:       "16a7e92bda105afe709a1e1c36e23d1bb30a8954259eb0fd9233ac51901d57de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "92707f24439158df63df9d1996161423635464df5a8d6d6e87af9438ec60ef7d"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    system "cargo", "install", "--bin=stellar", "--features=opt", *std_cargo_args(path: "cmdstellar-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}stellar version")
    assert_match "TransactionEnvelope", shell_output("#{bin}stellar xdr types list")
  end
end
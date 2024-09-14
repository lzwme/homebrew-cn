class Riff < Formula
  desc "Diff filter highlighting which line parts have changed"
  homepage "https:github.comwallesriff"
  url "https:github.comwallesriffarchiverefstags3.2.1.tar.gz"
  sha256 "3e2970b757b877e1399741da5727534a304cbf8cbe98d8b9fa81cb70494b33a6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "e1800fe18afb7773efb6b4831a916dc85bd5968246e5c0efcef883620a1464e4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "68cd6bca2a111377db65c24525b17a55408803dea7d28df124b4da75d4207c6d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f942963922bef0c30756ae50bf1fb185dda627bb14265da3f37e479bfd5b075b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d7ae6d89d475db44c811cb53d0635420ad7ce798f25e5174b6d2ebb9e79dab0d"
    sha256 cellar: :any_skip_relocation, sonoma:         "1c56898c3ed1237519ac376386a74239850c1c908f50cb3fc761041e641a262d"
    sha256 cellar: :any_skip_relocation, ventura:        "1fd9d0b525dfbe570ff701fb5e012f94e979e58fbc612acc3124e44dbe7e1495"
    sha256 cellar: :any_skip_relocation, monterey:       "3ad31a37588c74166dfc40cda9511d6eb97fe06db2ee2939e52c56b8f14a9579"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c6eedabf6d6eb84840b0e24d743252acbdb1a7bf51b0f0374db81677d767294"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_empty shell_output("#{bin}riff etcpasswd etcpasswd")
    assert_match version.to_s, shell_output("#{bin}riff --version")
  end
end
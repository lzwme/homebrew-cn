class Rainfrog < Formula
  desc "Database management TUI for Postgres"
  homepage "https:github.comachristmascarlrainfrog"
  url "https:github.comachristmascarlrainfrogarchiverefstagsv0.2.10.tar.gz"
  sha256 "fbcbd03fd92a43a34e2090fe776fc241d253e254c3ced91f18bb7b2328ea307d"
  license "MIT"
  head "https:github.comachristmascarlrainfrog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0e4716b7ecb2c263c7f3f0a65b518fffb0c3ff5be6be2e19f1581615aa3e5eb3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fee3b5c6da5e50aa36c80df06ed1e0d2326be93182f163bc1d0ddcbab4b70e32"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9b39fd4b8db8d42ca250b88045014d77e02354152d7ff12fb0b9a8aa189db206"
    sha256 cellar: :any_skip_relocation, sonoma:        "a183342b9ba4142b118b7e0dfd52db9dd3521d0bccda634cfb23318a4e92c8db"
    sha256 cellar: :any_skip_relocation, ventura:       "02de84d7e4c27198ec0edd9dd67c96e1580a227b4862c45a2735133158b1a8fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "577af890c3692f8fd742ad1a30ed113d266e2888ae76852690f997a45127a4dc"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # rainfrog is a TUI application
    assert_match version.to_s, shell_output("#{bin}rainfrog --version")
  end
end
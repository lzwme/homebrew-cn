class Svls < Formula
  desc "SystemVerilog language server"
  homepage "https:github.comdalancesvls"
  url "https:github.comdalancesvlsarchiverefstagsv0.2.10.tar.gz"
  sha256 "c81a830e932fc4343d5eb67b7aeb29eedb6f757899ae14f84323363acefb8718"
  license "MIT"
  head "https:github.comdalancesvls.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7c604b3f1f0d8ece5e91ee57ca464e73f5b781d3c2b35c7c4758c9459c7225de"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "812c8e5a373fbb0b91cac2e53201962894fbb5964f47f18a12884585d217f81c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "037a7f8c31f389a0257bf02cddbd510698206227f1aa8a42df16a86509462982"
    sha256 cellar: :any_skip_relocation, sonoma:         "32c2c1352a2605017e18dc59c7fd79e25aa5733de186f4db61480db664d35ad3"
    sha256 cellar: :any_skip_relocation, ventura:        "5db27d27f35457980e4919e978b022b5aa87b6659fe55bfd1c2b8b39e037c9aa"
    sha256 cellar: :any_skip_relocation, monterey:       "e6119b2acc0c6c15455c20b3b7ce895859635de547283a7f0b896dc79db8b69b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "071fb703a58116c66da8814e28af2dfbd25191a54f4166cdb86a4e1e6b77f28c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = ^Content-Length: \d+\s*$
    assert_match output, pipe_output(bin"svls", "\r\n")
  end
end
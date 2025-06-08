class Gitu < Formula
  desc "TUI Git client inspired by Magit"
  homepage "https:github.comaltsemgitu"
  url "https:github.comaltsemgituarchiverefstagsv0.33.0.tar.gz"
  sha256 "43dea7dae5f9aef9d3edb2f4e6ddd16d21664a6739b2856d53471846a97ded7d"
  license "MIT"
  head "https:github.comaltsemgitu.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "94369b51fac1600013f78476f5fd6b2aa5d40be4b905ac6abab89a1421460da7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b8b95ca1908b0544140450730a711ac6009cac6752788425411d8ea70bcc6f4a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "325a3a1a68ad8a5cdf1271a9f686df372586e47e1fbfb90e78abe04baf7583dc"
    sha256 cellar: :any_skip_relocation, sonoma:        "d6cf65fbcf1a6aad660e62286349db1052925d38419e39119a117170cf7a97e4"
    sha256 cellar: :any_skip_relocation, ventura:       "3c711f90d369934713ff9b37f745daf5d432ee44dcd49883edeb02a9dcfbc8a2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2cd4ee400d3f456150223a61f8c5477157a137e3d8dbda9433d5ca8159d24918"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "82074bc671b846a610d3e4245c698f31a99c21fdbe37eb6175e67a20b68e6bf9"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}gitu --version")

    output = shell_output(bin"gitu 2>&1", 1)
    if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]
      assert_match "No such device or address", output
    else
      assert_match "could not find repository", output
    end
  end
end
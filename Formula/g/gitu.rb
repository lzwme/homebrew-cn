class Gitu < Formula
  desc "TUI Git client inspired by Magit"
  homepage "https:github.comaltsemgitu"
  url "https:github.comaltsemgituarchiverefstagsv0.15.0.tar.gz"
  sha256 "2f1055514eb010dd50aa8b724356d981bb31b7c30b12a771f6cba08e73137d2e"
  license "MIT"
  head "https:github.comaltsemgitu.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fb000c5f96712d0c16dad078d8a5dfb5ac70584f2feea924a1c7d6c90683922d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b7bb8540e2870d844a66b505a7e0d86df6a15a6f15367b8b24bf30154a4fcc42"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "38568bba3ba734deb6d7446f978a1134d11f6cb418a8b84e93fe8e3f8cf2a772"
    sha256 cellar: :any_skip_relocation, sonoma:         "ce7cdf4d01a3e1396705cefe0f10f6b533f258187d09bbc89d34b18acfd91d56"
    sha256 cellar: :any_skip_relocation, ventura:        "d4f96815008c7608615ece1b25e5e1e24879199ac8b8923a2655522bc0f256cf"
    sha256 cellar: :any_skip_relocation, monterey:       "f9d75c0b89ba657287b2d88e3a5734a8fe0ffec7155eee87d8952eb918962d06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9673eca96206d877f4c5ab56599b68a5c91ee7ce4884279875f882107d1cb394"
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
      assert_match "could not find repository at '.'", output
    end
  end
end
class Starship < Formula
  desc "Cross-shell prompt for astronauts"
  homepage "https:starship.rs"
  url "https:github.comstarshipstarshiparchiverefstagsv1.21.0.tar.gz"
  sha256 "2f068545f270733add06c90592f3fb36422b8f650853f707956d24c06041b751"
  license "ISC"
  head "https:github.comstarshipstarship.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0358b562b3e844d4b7024842d4ca40b20ea4a20451549d906a21c3d012acae29"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6dcc0bfda692c887d4acf81cabb1a06216d44eaeffafc05d02146e85cc09b737"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dee56502f4dea601f46dfb5e87c447bdd69ea3fbb571caf45fbe590c42f2e708"
    sha256 cellar: :any_skip_relocation, sonoma:        "d659c85ad2e364b68a0813c69ba917dc4d34e89ff308ff6c71a39321b8b99d0e"
    sha256 cellar: :any_skip_relocation, ventura:       "2097b3ddb22d4b9a5c96cbd07c1d1a9be077518c3cae82ba8724dfc779e98286"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "73b7ad55a5865bdeb0e41c25ece53f5825d6903dab7c861d48fd462e3420073f"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "dbus"
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin"starship", "completions")
  end

  test do
    ENV["STARSHIP_CONFIG"] = ""
    assert_equal "[1;32m❯[0m ", shell_output("#{bin}starship module character")
  end
end
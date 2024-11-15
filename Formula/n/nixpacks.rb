class Nixpacks < Formula
  desc "App source + Nix packages + Docker = Image"
  homepage "https:nixpacks.com"
  url "https:github.comrailwayappnixpacksarchiverefstagsv1.29.1.tar.gz"
  sha256 "0694b453b12155e3f0822b185141e769d47efe0f09ce913bbeb57bacdf625748"
  license "MIT"
  head "https:github.comrailwayappnixpacks.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1e29c50f63e13a5dbaef01982c3b34c495860e639df9e284de2358723dda1f7e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "000b243a89194146013ebeeda588f2ffd7e61dbdde487e456872a090ee1061f7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "239179e1ecd3b712d32fa673448f5eca1c206ab821448876090ceecc34cec442"
    sha256 cellar: :any_skip_relocation, sonoma:        "f03b642e564996b6908646d47e7ac90bddb17909406394f21300e789db1303d2"
    sha256 cellar: :any_skip_relocation, ventura:       "3645a5ce2fde51843b4c64b57db5d66a85bb0b262041435eccc8ef7f72729439"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "37f5db6062c02262694f4f33588d104f6a9e6f0e7d398746f3f73d02cf199fac"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}nixpacks build #{testpath} --name test", 1)
    assert_match "Nixpacks was unable to generate a build plan for this app", output

    assert_equal "nixpacks #{version}", shell_output("#{bin}nixpacks -V").chomp
  end
end
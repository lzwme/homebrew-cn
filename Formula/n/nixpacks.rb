class Nixpacks < Formula
  desc "App source + Nix packages + Docker = Image"
  homepage "https:nixpacks.com"
  url "https:github.comrailwayappnixpacksarchiverefstagsv1.31.0.tar.gz"
  sha256 "9d30cdb23b8b940d0a041e0ad944d34fe524ee4d64ea5348d8b817dcd8bcf61f"
  license "MIT"
  head "https:github.comrailwayappnixpacks.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b0a5537de22aae7ba9e205ac92e74dfa8b431c3a947fa93d1fdf854822bf4609"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "38a92a54d82722bd828f7ac97e4311e7d8c501ec85dc0b3aaa9eb3cd30e5e176"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2c5f21bd6334cdecab77be9e43fc79cb296224a255c10db058da36918b6493ad"
    sha256 cellar: :any_skip_relocation, sonoma:        "908c7c803e3e36abe6481ba5d978427a31162f7cfb7a9c873423cc7df67b5e90"
    sha256 cellar: :any_skip_relocation, ventura:       "e15a55e038821422bd83989b416a01fc58572f8283521b01eb4d419219e41a75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "613fd67081548c2602bca9c51d1c26433485d17c05a5217ba7a10b2c9b5c8c3a"
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
class Nixpacks < Formula
  desc "App source + Nix packages + Docker = Image"
  homepage "https:nixpacks.com"
  url "https:github.comrailwayappnixpacksarchiverefstagsv1.21.0.tar.gz"
  sha256 "559cfb9c73da174ea4999d5ac93cb19408244db15b4fc773e31a10d24489d772"
  license "MIT"
  head "https:github.comrailwayappnixpacks.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5291dc7198bb0dd42476e61f7c7da86ee459451ff92e64367ef94af6b84df74d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1927fcd00686208ebd4a0198f1b974cf31eb402075a025c467222024cfefe675"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "61c00ea3e2b23a5d913a264216d2364178eedca6c7c1906d1905c3b2b7125e52"
    sha256 cellar: :any_skip_relocation, sonoma:         "a47c1587f002d4801444f333be34abcc20df3202a2c2850dd7638a224c5f183b"
    sha256 cellar: :any_skip_relocation, ventura:        "bc1093c698a768772db79419d3787de70884751c868843d7e6366a32dd4d4da0"
    sha256 cellar: :any_skip_relocation, monterey:       "8bb4455a687faa7308c3b83af52917b5be1f19efaccae6f0332a30ad2ddeb010"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "afcd3562ebcce19602ae7295fd1c2bf857724d4a71b273fd22148538e1d0ff79"
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
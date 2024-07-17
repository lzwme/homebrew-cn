class Nixpacks < Formula
  desc "App source + Nix packages + Docker = Image"
  homepage "https:nixpacks.com"
  url "https:github.comrailwayappnixpacksarchiverefstagsv1.24.6.tar.gz"
  sha256 "e1085fb41c301ff1433eccd8040fe5cd94bf0e80e5affa51125c4caaa620ec3d"
  license "MIT"
  head "https:github.comrailwayappnixpacks.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0b1c0fe3b95e273eaa2016fec96f29c85ba02d036591363c6a85828b9f081f30"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "21299c7057a109e9781e78f7a541fa11519746d12d6a4d8200ca7239bd89b5fb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dd96201ed0698bd7c391960c6057cd2257c0221ebc9e51bdb991b52277f53d6c"
    sha256 cellar: :any_skip_relocation, sonoma:         "c6d9f0674f64f63bd8bb00d9fa918427fd2f2d80f929865bafa62a1a8075111c"
    sha256 cellar: :any_skip_relocation, ventura:        "87d049fd46252077767d9b9b80018f69df707e53688db032a22ed52eddc97332"
    sha256 cellar: :any_skip_relocation, monterey:       "b941c9f2c4aac0756264e80eb0deed01989a957b62210cbc1cf095faba172bdc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fcf8419e890cced5053bd07522f9bf74f8e7031d0bbaa428070bd5d9fa838447"
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
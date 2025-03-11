class Nixpacks < Formula
  desc "App source + Nix packages + Docker = Image"
  homepage "https:nixpacks.comdocsgetting-started"
  url "https:github.comrailwayappnixpacksarchiverefstagsv1.34.1.tar.gz"
  sha256 "62c940db93fd282c429eb5ef66abf3a88d9d7846dac7213ebb5b183e197f7315"
  license "MIT"
  head "https:github.comrailwayappnixpacks.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "92f174d100ed146bb596503180dfa3fdd3dcd3967cae08614cbef33966da2e67"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dc54faf7e553233703bc00b59220153c653c2dec4eaeaa4bef6ec3c985f5a716"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6059b725fb33cf85991dadf71aafd97429198ec19eacc380c7ff9f4510840ca7"
    sha256 cellar: :any_skip_relocation, sonoma:        "f7155c4592aa423713a34f6242d7b349bcdb5405e067a9b8f999f01b685be4c4"
    sha256 cellar: :any_skip_relocation, ventura:       "a0ad90ae560194a6ed3f96ad22ee0613163a9596f0edf0b078c62aa20d0d6f41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d6845520f9ea9be92688453056cb489cd55cbc7b8db35c53b1df7a2d89fd454d"
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
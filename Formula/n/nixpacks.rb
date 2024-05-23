class Nixpacks < Formula
  desc "App source + Nix packages + Docker = Image"
  homepage "https:nixpacks.com"
  url "https:github.comrailwayappnixpacksarchiverefstagsv1.24.0.tar.gz"
  sha256 "50c0d68ddefdd90e4c8b93d871ba6df76f749b4aeea4fa479945a5a740e040ac"
  license "MIT"
  head "https:github.comrailwayappnixpacks.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b5f904453585c68d4913ef13093dca91b114a5a77b651df000e91f68e3949d4e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a6ae7fc99a2df9c7f17cd74d45760af296ec60b5839a5643b3bfdf1d18070419"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d1e38a864f2435ff14c7396adf6244c6bbe3c430382602c2142c38eef9f69484"
    sha256 cellar: :any_skip_relocation, sonoma:         "62cf35224e861c47d33ddc77275ca59742a2447d223623f58466d0dc542216f5"
    sha256 cellar: :any_skip_relocation, ventura:        "1340111cfe433a79bb5fb5f44a8a1cd68b61cb8f9008823e91a6026fa492e58b"
    sha256 cellar: :any_skip_relocation, monterey:       "4b2d9649ac2c1397cbabb6271c3f1ce23ad99c9b78aecf6288a9ce66ea7d9afd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8da379b1ccf4eb6743b3e39cca50e4eb2d89df5c8292d9f266ad943c014a7803"
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
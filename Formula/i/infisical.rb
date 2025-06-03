class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https:infisical.comdocsclioverview"
  url "https:github.comInfisicalinfisicalarchiverefstagsinfisical-cliv0.41.5.tar.gz"
  sha256 "a8cb24c0ff750504cbe1683a2962d0c8114d3a3c12f266c0b811e0b151877995"
  license "MIT"
  head "https:github.comInfisicalinfisical.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^infisical-cliv?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "28ea360c2b9d10fe9fb869d5e4aa242e425982cb455cba92dfbd3d4454d36edb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "28ea360c2b9d10fe9fb869d5e4aa242e425982cb455cba92dfbd3d4454d36edb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "28ea360c2b9d10fe9fb869d5e4aa242e425982cb455cba92dfbd3d4454d36edb"
    sha256 cellar: :any_skip_relocation, sonoma:        "7d9e12994c34e8da8d1dc292048d05410bfe63c9ed9a1740acff31362d48d9dc"
    sha256 cellar: :any_skip_relocation, ventura:       "7d9e12994c34e8da8d1dc292048d05410bfe63c9ed9a1740acff31362d48d9dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5940418a8305b16349ccc904da132ff7be73c40b838861e1942ff6da479a29ff"
  end

  depends_on "go" => :build

  def install
    cd "cli" do
      ldflags = %W[
        -s -w
        -X github.comInfisicalinfisical-mergepackagesutil.CLI_VERSION=#{version}
      ]
      system "go", "build", *std_go_args(ldflags:)
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}infisical --version")

    output = shell_output("#{bin}infisical reset")
    assert_match "Reset successful", output

    output = shell_output("#{bin}infisical init 2>&1", 1)
    assert_match "You must be logged in to run this command.", output
  end
end
class Yoke < Formula
  desc "Helm-inspired infrastructure-as-code package deployer"
  homepage "https:yokecd.github.iodocs"
  # We use a git checkout since the build relies on tags for the version
  url "https:github.comyokecdyoke.git",
      tag:      "v0.11.4",
      revision: "b86881c1c75fb0ffb92e8ac15c7b400e9c5e3847"
  license "MIT"
  head "https:github.comyokecdyoke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6d9d409ff64a13d65f848fc2cdc6a6efed551879c4b51634228331ea1b74295b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8a9d1f69eb9096b2a2775e64294572eb137a725136716ddda856df78055d0d26"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5ba07c1107fd0069409225dcf3cd0817350c2fda4e0cfb4a624a07320ec9b3d5"
    sha256 cellar: :any_skip_relocation, sonoma:        "199c8e222ed75b88b20d512911dd0d2e90bab1706b4065551c8f0b578dec0172"
    sha256 cellar: :any_skip_relocation, ventura:       "17fac4486ce145a1e5c9e10ce23e1d8d292a42ce10e192ccd92e218d157f24d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a70ae8e8d225d416688476fcec1f01d5794f32566798a88c9c1cb30e31b40772"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmdyoke"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}yoke version")

    assert_match "failed to build k8 config", shell_output("#{bin}yoke inspect 2>&1", 1)
  end
end
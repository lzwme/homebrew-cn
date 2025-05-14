class Yoke < Formula
  desc "Helm-inspired infrastructure-as-code package deployer"
  homepage "https:yokecd.github.iodocs"
  # We use a git checkout since the build relies on tags for the version
  url "https:github.comyokecdyoke.git",
      tag:      "v0.12.7",
      revision: "16303ef5ec0ef6f0b8757cfb5b730f95ba2f33b1"
  license "MIT"
  head "https:github.comyokecdyoke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3afd21ea1cb4562da21d5119970b026d36312c1c1e48261d7f78249d368fba49"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "473182ec76837e592bcbb8ed32aea8bf5df4df79355e77626094ceec5933e804"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "290cf8e60f8707c230e6c00d81b4ffea7e71b8d69e7fb0f9e71b79031df18bb8"
    sha256 cellar: :any_skip_relocation, sonoma:        "c6cf62088b2fa5862e510f8414951eb985a7bc01b33849fe1550cd2f49d60d0b"
    sha256 cellar: :any_skip_relocation, ventura:       "b28b38152f5c7180bb72cf27b68ef93deda2753796f8cb732af92728a928fe03"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "af09c6f6977f11733f687f068feac6aaf67a6c0b97b0ed847734ba58730a5a9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0de857cdd1495526c741dc316eb0ef26899b86d70db636bf60e2ae07b38e9c87"
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
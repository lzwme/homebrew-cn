class Scarb < Formula
  desc "Cairo package manager"
  homepage "https:docs.swmansion.comscarb"
  url "https:github.comsoftware-mansionscarbarchiverefstagsv2.5.4.tar.gz"
  sha256 "d9c3d2b4d688fd6035f689b556e4fe5e176d3e882fb45108dac117206be7160f"
  license "MIT"
  revision 1
  head "https:github.comsoftware-mansionscarb.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7768ede4acb9362e8ee3e7d6963f0dec6e1cde8e0dcefb61d6a9ba450ac1436e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b90fc120479a32cafa0da45e3f656c7c6c05a06cfeb12ad79b656f53118d4061"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "050b37c2fdf84eeb2f334eb746cb345635ab05d658af2f998aeabb0342d56a7b"
    sha256 cellar: :any_skip_relocation, sonoma:         "03c0f03009dfb7c0b6746d63b2376338887126f78f8b5796b241af260400902f"
    sha256 cellar: :any_skip_relocation, ventura:        "eaa974d863e928e65c58e86dcdc0efa92fdb8e57893b6c3322dd5c4e86e89c52"
    sha256 cellar: :any_skip_relocation, monterey:       "b4bfa95e829e7d38c8634744ec392baa85a3dc8b0eec5ae07be64fe122a30053"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1713ece056b9646745f8c96af3afd859b78d59e581d6e449cbdbefbee24fa499"
  end

  depends_on "rust" => :build

  def install
    %w[
      scarb
      extensionsscarb-cairo-language-server
      extensionsscarb-cairo-run
      extensionsscarb-cairo-test
      extensionsscarb-snforge-test-collector
    ].each do |f|
      system "cargo", "install", *std_cargo_args(path: f)
    end
  end

  test do
    assert_match "#{testpath}Scarb.toml", shell_output("#{bin}scarb manifest-path")

    system "#{bin}scarb", "init", "--name", "brewtest", "--no-vcs"
    assert_predicate testpath"srclib.cairo", :exist?
    assert_match "brewtest", (testpath"Scarb.toml").read

    assert_match version.to_s, shell_output("#{bin}scarb --version")
    assert_match version.to_s, shell_output("#{bin}scarb cairo-run --version")
    assert_match version.to_s, shell_output("#{bin}scarb cairo-test --version")
    assert_match version.to_s, shell_output("#{bin}scarb snforge-test-collector --version")
  end
end
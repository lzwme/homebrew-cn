class Scarb < Formula
  desc "Cairo package manager"
  homepage "https:docs.swmansion.comscarb"
  url "https:github.comsoftware-mansionscarbarchiverefstagsv2.8.5.tar.gz"
  sha256 "18a07a0a09946f276ab399cddff1d6a6bccb342da903204dd88e804df6f478a0"
  license "MIT"
  head "https:github.comsoftware-mansionscarb.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b5e5ad817c5e8634bc9f7b9cb8be4fe8eed216825b9e65885cf94088b0868a48"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "70a84c6e76582540af3243e0e052f6f998c444b110959a0d3c1c0150840f7f21"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a5c2f567237364e2c14f08469c18b674f43b9b7ba19016b86f0db0e37ec09848"
    sha256 cellar: :any_skip_relocation, sonoma:        "48cf60524abe4c4271d7db2dcc1dc022f716cca785a30a245930883b68c4d8cb"
    sha256 cellar: :any_skip_relocation, ventura:       "9357aef48ccb1561640845755fd00e619a37f7cc1739d6695b9b4d5ac7e75114"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "532733488fc64bbfdb9a1669b2819285cdb61e9e5b62e706d02f19d10881133c"
  end

  depends_on "rust" => :build
  uses_from_macos "zlib"

  def install
    %w[
      scarb
      extensionsscarb-cairo-language-server
      extensionsscarb-cairo-run
      extensionsscarb-cairo-test
      extensionsscarb-snforge-test-collector
      extensionsscarb-doc
    ].each do |f|
      system "cargo", "install", *std_cargo_args(path: f)
    end
  end

  test do
    ENV["SCARB_INIT_TEST_RUNNER"] = "cairo-test"

    assert_match "#{testpath}Scarb.toml", shell_output("#{bin}scarb manifest-path")

    system bin"scarb", "init", "--name", "brewtest", "--no-vcs"
    assert_predicate testpath"srclib.cairo", :exist?
    assert_match "brewtest", (testpath"Scarb.toml").read

    assert_match version.to_s, shell_output("#{bin}scarb --version")
    assert_match version.to_s, shell_output("#{bin}scarb cairo-run --version")
    assert_match version.to_s, shell_output("#{bin}scarb cairo-test --version")
    assert_match version.to_s, shell_output("#{bin}scarb snforge-test-collector --version")
    assert_match version.to_s, shell_output("#{bin}scarb doc --version")
  end
end
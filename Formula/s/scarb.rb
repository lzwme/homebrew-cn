class Scarb < Formula
  desc "Cairo package manager"
  homepage "https:docs.swmansion.comscarb"
  url "https:github.comsoftware-mansionscarbarchiverefstagsv2.11.2.tar.gz"
  sha256 "d07b7f1190c75d84731481c9b64b99806940d0e11f915b4b83088e25aba0fae6"
  license "MIT"
  head "https:github.comsoftware-mansionscarb.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ffb303bc63591f68d45c3f32ad7ac704145cf4a2c9835ff55d5eb756b8487807"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4096cc42fb8dde182ffd554ffb04ac2c0167058afcacd2af6581063cc768bbed"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2493d4a84e12fce0d94431c7f2d8062c80956c1e7e6c192b7875589e3185d914"
    sha256 cellar: :any_skip_relocation, sonoma:        "0c4d353bbdd41fa4d6e5cf5fbb2eaba944860868766a5ec6e0b1114c2c4d3b33"
    sha256 cellar: :any_skip_relocation, ventura:       "8ddb4a0ae970bf7c64ce8ebeeafc37a5e3bdd46e2f06ac9ba64cf9ca343d6487"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e303dc4efe9367f106ff8c0db3435d3b867a0b79afe6eb221fadc9cb9368c089"
  end

  depends_on "rust" => :build
  uses_from_macos "zlib"

  def install
    %w[
      scarb
      extensionsscarb-cairo-language-server
      extensionsscarb-cairo-run
      extensionsscarb-cairo-test
      extensionsscarb-doc
    ].each do |f|
      system "cargo", "install", *std_cargo_args(path: f)
    end
  end

  test do
    ENV["SCARB_INIT_TEST_RUNNER"] = "cairo-test"

    assert_match "#{testpath}Scarb.toml", shell_output("#{bin}scarb manifest-path")

    system bin"scarb", "init", "--name", "brewtest", "--no-vcs"
    assert_path_exists testpath"srclib.cairo"
    assert_match "brewtest", (testpath"Scarb.toml").read

    assert_match version.to_s, shell_output("#{bin}scarb --version")
    assert_match version.to_s, shell_output("#{bin}scarb cairo-run --version")
    assert_match version.to_s, shell_output("#{bin}scarb cairo-test --version")
    assert_match version.to_s, shell_output("#{bin}scarb doc --version")
  end
end
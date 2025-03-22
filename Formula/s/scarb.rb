class Scarb < Formula
  desc "Cairo package manager"
  homepage "https:docs.swmansion.comscarb"
  url "https:github.comsoftware-mansionscarbarchiverefstagsv2.11.3.tar.gz"
  sha256 "aff4ff3f29f1c32aad5dc771584f5c69b4ba25957cad4c9959a53418406ebfd2"
  license "MIT"
  head "https:github.comsoftware-mansionscarb.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5cc5029e46b30b797b691d883a10f1e2781ac9eb12ddfdd83dda93b6e6dc319a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4cd1191bb3755ad7103b4a4937b0b14a0ecdbb4dc6dd97b82414b0007244e566"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "55f8f800149fee468a9d729fb39e12344a1107ae7ae95ae79f064767f02bc756"
    sha256 cellar: :any_skip_relocation, sonoma:        "4a9c862289b03f99a2a4e0af2f6c09a5788e2febe3543bed0c3e8f4c37cfcbe3"
    sha256 cellar: :any_skip_relocation, ventura:       "f1637ac3de7be19fe07b99f2e634239560d61ba7f0778372a3d45ceb4770b549"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4fb168bdda21478d1ec70be6a5db8a6d6c61557e95e06a09fe47c1b942f14e2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8cd58e7a7dc6ee69e6d80a39e51cf357de3913a3ca3c7afbe22cb827dd294b95"
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
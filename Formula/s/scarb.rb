class Scarb < Formula
  desc "Cairo package manager"
  homepage "https:docs.swmansion.comscarb"
  url "https:github.comsoftware-mansionscarbarchiverefstagsv2.7.0.tar.gz"
  sha256 "9ef9b3a2242f9b951194effc2b087a62cb2947d4ac6af5f90c974d6eefc400d5"
  license "MIT"
  head "https:github.comsoftware-mansionscarb.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2f0fd22beb36fd6fe538f96cff1d032e9b5549a95581f17a6e16e8ba6205fac5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c6e0e615e0b88ffcb18f4f883c017aeb6d0e743fe64c9e0606de87de8c0b4050"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "36366997f8dfd526cb6d3a6dfda6a18d6266420492fd924e801beb431fb5e0ec"
    sha256 cellar: :any_skip_relocation, sonoma:         "5b476b20ae06987d6e69411a3cbab34eda40ccc3a02102a43a66b3ebcfdacd52"
    sha256 cellar: :any_skip_relocation, ventura:        "bcfdd287d7521364880c151d6ab81cae66e4f5d9bd4bbe963787f6e0e8ab5bc3"
    sha256 cellar: :any_skip_relocation, monterey:       "02b75da90f69cf8474addf0b481eb004153adfa1a6c7d7077e45c27b136eed4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "29d82e1d130015347b32ec29dcdece19b839a64d2bf439150481957c8eeb54d7"
  end

  depends_on "rust" => :build

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
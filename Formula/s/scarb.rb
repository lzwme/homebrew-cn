class Scarb < Formula
  desc "Cairo package manager"
  homepage "https:docs.swmansion.comscarb"
  url "https:github.comsoftware-mansionscarbarchiverefstagsv2.8.2.tar.gz"
  sha256 "8d56c22c7b565750caf69aaeae615a12ae67b2dcea52eb795165374e56d630ea"
  license "MIT"
  head "https:github.comsoftware-mansionscarb.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2aec3219f9609f1a3063daea3de7472f531a6e61ea28715ce115fab423eb0005"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "591e9237d2ced5c33ccb3cd0573c77a8d27efe37d87003b44854fd8418f99254"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ec66150dc73d8743dca99a18e18523e9ab7c2a632df87ad0c3690a392260d87f"
    sha256 cellar: :any_skip_relocation, sonoma:         "32052c2448e2b33166807ae9bdec756165421905db4e8c0ed7bc3e8920a1a846"
    sha256 cellar: :any_skip_relocation, ventura:        "fe23950637c63c765f28471abe50873dd1f465b7056e42c64bd63489c5ef6f61"
    sha256 cellar: :any_skip_relocation, monterey:       "c4a7a88bf2877f6808b12140010040f9266b39a4543654f4b5413809e5fb515b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b2c81d4e4ecdf39f7e0f9ad7db61aebe6801fbe1b9358117a11b6ca1572e779c"
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
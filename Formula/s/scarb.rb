class Scarb < Formula
  desc "Cairo package manager"
  homepage "https:docs.swmansion.comscarb"
  url "https:github.comsoftware-mansionscarbarchiverefstagsv2.8.1.tar.gz"
  sha256 "e7bc798d8710137a6db126bea82953963601a3bd28c5f2dd831b12dd3173ec87"
  license "MIT"
  head "https:github.comsoftware-mansionscarb.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "87c0ef93ce29c04c2fe39c8477daf64734f7a238971828285b7b1aa4e8a44c50"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "85958b46328e38d2643b491c05183900f4bdb805f75f88070558780db1f8738b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8d6a14410014cc8294234cfa5109b7d35c3191461a439e7083703e724bbf0dac"
    sha256 cellar: :any_skip_relocation, sonoma:         "8712edad0ae91bb5c9ca492cf672888a3b834f29dfc427f0ed0d5d92e622bdad"
    sha256 cellar: :any_skip_relocation, ventura:        "3b81e984934744036bd7ab5fa3b079cf576a8b1e92f1741d400d972a4117846b"
    sha256 cellar: :any_skip_relocation, monterey:       "dd82289262de453c160859217c9e416b18ebfb8eec267fc17685688565f8901d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "60530a9baf2b3cbb19ec6999a1d05565f69d9ff33cf12535b3db2d110abdcd4b"
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
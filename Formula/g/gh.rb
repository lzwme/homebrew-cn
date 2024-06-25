class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https:cli.github.com"
  url "https:github.comclicliarchiverefstagsv2.52.0.tar.gz"
  sha256 "41de39d0f1bcacb454d9b8a46e5b97ff8b8e803cd26d284e553e45bf025325d9"
  license "MIT"

  head "https:github.comclicli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "798bb3344422a39c761143d9bae1de7b0c031d70c830f10d584a9e05ce3f602e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "874034c7fc527c5ea79c0b12abe505e3e47b3af6f6989f310102ca6efa5be3bf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "95e7ffa257ce95145428fd548443af5eb6e3c260fc2a2cc76a8cada864400ac2"
    sha256 cellar: :any_skip_relocation, sonoma:         "6e036bba9386707b1fe7c4291bb4b991ea5da9ee330c33c68a90f9f3ba60e2e7"
    sha256 cellar: :any_skip_relocation, ventura:        "cb9be3971c2d7870278c7581f3e10f73f68aef342e74f68fdf09a5b821a0d159"
    sha256 cellar: :any_skip_relocation, monterey:       "bb1dd5cb0ecc813cb5370cdd6e2f857242840c8f69bc97a8db1fcc7a790e917f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d40655ec9bd976b2f22756e3034f10bed5adab8e519b794933bde79b2205509d"
  end

  depends_on "go" => :build

  deny_network_access! [:postinstall, :test]

  def install
    with_env(
      "GH_VERSION" => version.to_s,
      "GO_LDFLAGS" => "-s -w -X main.updaterEnabled=clicli",
    ) do
      system "make", "bingh", "manpages"
    end
    bin.install "bingh"
    man1.install Dir["sharemanman1gh*.1"]
    generate_completions_from_executable(bin"gh", "completion", "-s")
  end

  test do
    assert_match "gh version #{version}", shell_output("#{bin}gh --version")
    assert_match "Work with GitHub issues", shell_output("#{bin}gh issue 2>&1")
    assert_match "Work with GitHub pull requests", shell_output("#{bin}gh pr 2>&1")
  end
end
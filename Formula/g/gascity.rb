class Gascity < Formula
  desc "Orchestration-builder SDK for multi-agent coding workflows"
  homepage "https://github.com/gastownhall/gascity"
  url "https://ghfast.top/https://github.com/gastownhall/gascity/archive/refs/tags/v1.3.1.tar.gz"
  sha256 "ec728d55175dacb5fa24e20c3f4fa3198c0414f748a16ce68dc19f83092d35fe"
  license "MIT"
  head "https://github.com/gastownhall/gascity.git", branch: "main"

  bottle do
    sha256                               arm64_tahoe:   "9d5e816bbea2fbb05db60a150b12a7883e5c8a751ebdd48a38e9cfcfe54008bb"
    sha256                               arm64_sequoia: "b39b46164b99829fc6f471b3e7238d38259607a2dffa093e904fac4be6dcdf52"
    sha256                               arm64_sonoma:  "5fd5c69d957508f6a17db2f177c5e3e0509454827738ee4d41eefe5d6bf917ae"
    sha256 cellar: :any,                 sonoma:        "83ab6e18e4ef4560e84ee7a273516a66eec2397957c07d6174c4d5d9176f670e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0e6c12e5b76ffb596aca0edb72e352148fbbeb74ec35d39161244c4aee1e7767"
    sha256 cellar: :any,                 x86_64_linux:  "ed499ebfe4783bd195f2b10bc53ec02962130ec7fecbacc1c3c99d582e3e6043"
  end

  depends_on "go" => :build
  depends_on "beads"
  depends_on "dolt"
  depends_on "icu4c@78"
  depends_on "jq"
  depends_on "tmux"

  on_macos do
    depends_on "flock"
  end

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"gc"), "./cmd/gc"
  end

  test do
    (testpath/"city-template.toml").write <<~TOML
      [workspace]
      name = "brew-test"

      [beads]
      provider = "file"
    TOML

    ENV["GC_HOME"] = testpath/".gc-home"
    city = testpath/"brew-city"

    output = shell_output("#{bin}/gc init --skip-provider-readiness --file city-template.toml #{city} 2>&1", 1)
    assert_match "Initialized city \"brew-city\"", output
    assert_path_exists city/"city.toml"
    assert_path_exists city/"pack.toml"
    assert_path_exists city/".gc/beads.json"
    assert_match "name = \"brew-city\"", (city/".gc/site.toml").read
    assert_match "provider = \"file\"", (city/"city.toml").read
  end
end
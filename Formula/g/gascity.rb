class Gascity < Formula
  desc "Orchestration-builder SDK for multi-agent coding workflows"
  homepage "https://github.com/gastownhall/gascity"
  url "https://ghfast.top/https://github.com/gastownhall/gascity/archive/refs/tags/v1.3.4.tar.gz"
  sha256 "afd7fc88d38fd4345fd01af97481d7bb34b03d0de87c8829bc839699ee62e556"
  license "MIT"
  head "https://github.com/gastownhall/gascity.git", branch: "main"

  bottle do
    sha256                               arm64_tahoe:   "340edea982f5dc97d8391df093dfd466bf6df8de22c22d69dd1506c2721e09fd"
    sha256                               arm64_sequoia: "d95e22c2afe1f0cf682c2bd8326375e85c6237c2ccfe955e2b5b81ad112838cd"
    sha256                               arm64_sonoma:  "851973c48364854f151d0df67f008f96dafae81478054b0d519692b4103202e6"
    sha256 cellar: :any,                 sonoma:        "018f7b7f1265489ffd920eddebd3165292dd3cb8698aee6cb1beeb17e4cae8c2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1598ac9b96d13b7540cb8bf39107942e693067b90cb90b40af0aea100eb3b556"
    sha256 cellar: :any,                 x86_64_linux:  "7ae4316e3598dc1aed529bad604471307d0bc0978484ad094a6e472c6aaa0072"
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
class Gascity < Formula
  desc "Orchestration-builder SDK for multi-agent coding workflows"
  homepage "https://github.com/gastownhall/gascity"
  url "https://ghfast.top/https://github.com/gastownhall/gascity/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "af94e8a9bbf276d4ba8278869f186339c702ffd3ef0eeb5666298484996f5390"
  license "MIT"
  head "https://github.com/gastownhall/gascity.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "10f506373765340f28590c5de9d5d096e8fb33d67a566ac2fbc2c8fe29e2c32c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "10f506373765340f28590c5de9d5d096e8fb33d67a566ac2fbc2c8fe29e2c32c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "10f506373765340f28590c5de9d5d096e8fb33d67a566ac2fbc2c8fe29e2c32c"
    sha256 cellar: :any_skip_relocation, sonoma:        "d93cccfbd39791403baafe2d13d8e17a13f53ca5bd2e4295b915e47d217d794d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "60a521b307674c4d810819965cdb38379c094f49f7ee91ab94a6fe9e46a021a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d7b25c3f29d5758c2ed8cec3a32295becbdf568224a93ea9c6c229780c01b4b"
  end

  depends_on "go" => :build
  depends_on "beads"
  depends_on "dolt"
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
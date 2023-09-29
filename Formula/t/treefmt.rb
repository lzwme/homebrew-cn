class Treefmt < Formula
  desc "One CLI to format the code tree"
  homepage "https://github.com/numtide/treefmt"
  url "https://ghproxy.com/https://github.com/numtide/treefmt/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "2d1e506e5c488b4da1061bc5bd5c91074b8d136bcfa90b6bd8c76c461d81224b"
  license "MIT"

  head "https://github.com/numtide/treefmt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f06934b7c3f526dc635681f59a78c8f66768c9d3764835aa925d39ef22203882"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "98a1d33fd5ac322f3f309f28ec942a6cd4f2e49206c9e1cfc7e11f633d304b85"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cfb60eca7db12e3527dfe858fd904c24d0ab3eba4895ce01e4954f60c103fe5b"
    sha256 cellar: :any_skip_relocation, sonoma:         "b892aeff88d1576dcad733f8bf5a1d76cc72bae3250bb4e6a635e54421079ef6"
    sha256 cellar: :any_skip_relocation, ventura:        "0e617dc388f7177becf3b05660e240ed2fa3468cdcb5dffb3b7c8831837f2eff"
    sha256 cellar: :any_skip_relocation, monterey:       "df15d38adad2365fdcbb2640466cba9e3a5b2552d8d6acb73595c959c0c12af7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "872db04b20754da18c65355c65953231746a9c17ac478db5f5a2fbc91ca3ea6f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Test that treefmt responds as expected when run without treefmt.toml config
    assert_match "treefmt.toml could not be found", shell_output("#{bin}/treefmt 2>&1", 1)
  end
end
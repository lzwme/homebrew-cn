class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://ghfast.top/https://github.com/open-policy-agent/opa/archive/refs/tags/v1.12.1.tar.gz"
  sha256 "52dbb092c56102fff61bb920d441e8b4f578f504ed087008015a9ae577d03caa"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/opa.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9c0dcfaa5029d42a22e211fc4cdf98134e7bf3866b3c05ec7112115d01d86aab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f9156d2c516824f6541640cb4118845455cea8af58c04e06c180f42234a3bcdf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "08a93195a4d84d717a30689a3e55cfc0243e105fae3b62ca841dc7f38fa5b477"
    sha256 cellar: :any_skip_relocation, sonoma:        "404324d1c44e9fe6ddbb7f427cc96efde09094732b02d80265bdd57af9f48bbe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a83f75bf24f71e0197abb674bf9445dd23501c8b94a94a729188ce0ba2b102c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2dd4496e16a2137e1069dda901eb62b0f02fd9afb2737515f10477d92c7b4aff"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/open-policy-agent/opa/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
    system "./build/gen-man.sh", "man1"
    man.install "man1"

    generate_completions_from_executable(bin/"opa", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output("#{bin}/opa eval -f pretty '[x, 2] = [1, y]' 2>&1")
    assert_equal "┌───┬───┐\n│ x │ y │\n├───┼───┤\n│ 1 │ 2 │\n└───┴───┘\n", output
    assert_match "Version: #{version}", shell_output("#{bin}/opa version 2>&1")
  end
end
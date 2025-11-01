class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://ghfast.top/https://github.com/open-policy-agent/opa/archive/refs/tags/v1.10.0.tar.gz"
  sha256 "c61567b0e20b2a2aa97e16235974a967d7be707a00adb13e2c85f9785005bb86"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/opa.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6314629f86084e82ad5bebd63c1336bb1bb08cfd865a3511be97ebeff64e1892"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4d378297259159ba63aa8dc15404b27c22197233a2ab76f34f262d3116324f84"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3a496abe4c93772e9604f152d5de9c655e5ab01f5cad8c7d96018d2c5513bf5c"
    sha256 cellar: :any_skip_relocation, sonoma:        "7e5c4f5b02df06c28badef27a825c11745a415055f3af49a5fc8332679797ce3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "36fa1dd609d7daea00077f30b5f566eb5f7f9563837d6ef3feb2f1b0a7968b8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e6a4e5ce774c6bb883da8c77914ebd7660c9a2a6ea3fe865412435edd10b288"
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

    generate_completions_from_executable(bin/"opa", "completion")
  end

  test do
    output = shell_output("#{bin}/opa eval -f pretty '[x, 2] = [1, y]' 2>&1")
    assert_equal "┌───┬───┐\n│ x │ y │\n├───┼───┤\n│ 1 │ 2 │\n└───┴───┘\n", output
    assert_match "Version: #{version}", shell_output("#{bin}/opa version 2>&1")
  end
end
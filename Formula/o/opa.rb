class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://ghfast.top/https://github.com/open-policy-agent/opa/archive/refs/tags/v1.14.0.tar.gz"
  sha256 "6d6fc004896d50d693efdf560f639fc28a980e6898b87b504ee14e7965d97f8f"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/opa.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bc8e6ac89d69e44c6ec24eccac955ba50ef61d575614367225e9dca9afebe59c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "662a11371ae915ad4f8989caf18d1c61612e02f49ee1e196a8ebd5bae7b5335c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cd59955b6a373882aff70d36c79f125be475966e9ca710c897eda48be9cfb97b"
    sha256 cellar: :any_skip_relocation, sonoma:        "f83b6f59a33907c5ffa978649225f2d128e1b7a51b342f2cea1816729a0f09bf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a569860c03cb5dbc7c11aede3f6450ad5e811c7d1a366ae984d02eea6241a974"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e8bc318b148a0bb516b490fe6a060703c2f1f3b2444c89bd58465b84fd0ae6e3"
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
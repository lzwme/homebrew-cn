class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://ghfast.top/https://github.com/open-policy-agent/opa/archive/refs/tags/v1.13.1.tar.gz"
  sha256 "24cc7bfc1b83180462b574f941790b8926a8a632b7b5fe29c1646165f3ef3c32"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/opa.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "af33a0f65619797bb0cd70be7522f69666a47c58e4d3029dce129d6cd85e7002"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1bb99c0c709e4f086b5ebcfdde8ea64bbc40597535f136c168db460f033c23b7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6135a9f679f19ddb05aff9cb16c72b263ad66c5f7426e0a29254e45bca01cdbb"
    sha256 cellar: :any_skip_relocation, sonoma:        "b5e4aca2e1d995782f3278310805b8e77babaab1f65aac4aa79a3041e4f0830b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a0c75925d5ed9ade03de7f5b8b9ced03ba8e58bb8a9557404d5d85c41ec46074"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3473223c3f717b979fa9978fb27e00f9895ca7340508b687de11df928f738c4c"
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
class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://ghfast.top/https://github.com/open-policy-agent/opa/archive/refs/tags/v1.16.0.tar.gz"
  sha256 "aaca80d1589dab33981d4b838397b32dd6261e09d2793ab3191a35e58b515b4f"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/opa.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "36999415985299bfa6fefe8447cddeea3850178cff2b5b42de4872be7bbc89a8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "406849b274d32d8b0e0eff43e53b2094bff1ae7fe492c1b1df943fe633ab41d4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c74e6bfad7dfc66ec05d1315ae9ae17c47fe1901170679a689e5706cdf9044f8"
    sha256 cellar: :any_skip_relocation, sonoma:        "beea5d789a39622d27153dbc60c7c64fccb3488f5f1a66bb46456cde5c6afebb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "05f26871446449b22e90066952e05b13610e04ca1d462c637cd18790994721f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d4569e36d874f9e5007b532ec60fb01be5486ae893a31270cf6a63ca425fdb01"
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
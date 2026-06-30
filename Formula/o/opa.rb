class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://ghfast.top/https://github.com/open-policy-agent/opa/archive/refs/tags/v1.18.1.tar.gz"
  sha256 "b778447b1b6c5c3c8ed67a468477697970db0135b5b20ffe75d510f65a4f4b52"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/opa.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f877b11329478e759e29360b6184d786d2b5dc58c1cb23d553cd95a7e6709c88"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "abefaff8b7365e394ca0643e979fe58e0038ce828a9cfb11f6eb014f09275e74"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5455b56572d601bf94d49b024c3c97bd69b59272f854b53af4ca4655dc7f3f92"
    sha256 cellar: :any_skip_relocation, sonoma:        "8be98d792b598319a2a0e49c591b864d29891583929daae72aaaa3f31a185294"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e44e2a23a7343d99c86340c16a028dfd9469d53ae99108d4220002d91c91bbe8"
    sha256 cellar: :any,                 x86_64_linux:  "aa1d1a30d4803932439e18d0222f1cda695ed51e93beec326cb70b3221ffdf5c"
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
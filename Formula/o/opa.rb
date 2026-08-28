class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://ghfast.top/https://github.com/open-policy-agent/opa/archive/refs/tags/v1.20.1.tar.gz"
  sha256 "c2219dda59cdfb74834bbd926c278d2f13c0fd42080888b0eff25ff04f97e8ce"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/opa.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6bf7572ca0b7fedcc62576480abf6b5f7e7f3e93700ff5fd099f44c68963354f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "96e44824590f9dbd38e3b382a667565f03da3c70a8a0d076642431ac76c0db6a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "90b9c06264d2d3fbf8e9ee49c2767d3536134a085761088769204721483bb78c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d01c64b8e627e4982365c485d706c513474bc8f6f32d8819ed3fcf1d7e7cda5e"
    sha256 cellar: :any,                 x86_64_linux:  "2dd487454912840adcf7abc0f4e5096371b28354d6a079b004bc2a7f3c31b1a8"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[-X github.com/open-policy-agent/opa/version.Version=#{version}]
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
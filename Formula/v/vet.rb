class Vet < Formula
  desc "Policy driven vetting of open source dependencies"
  homepage "https://safedep.io/"
  url "https://ghfast.top/https://github.com/safedep/vet/archive/refs/tags/v1.18.0.tar.gz"
  sha256 "0357b5982c337d5f769cb7f5f4103341203d0ab1e89addbdfb8147c5f90abed6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "530237f9b1a3ef3e4c5fedbf120395c54c1f3ec5c861b26b0f15f95489c4ff35"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d67df957ec0756ad9745222cab7d1ba77f0ff7db662c0d0bc6d1f05c60fdeb59"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1776ed36a3d4799503ac3d9f8da45fedea8f65c562f4e1f5e06e86377a9a5972"
    sha256 cellar: :any_skip_relocation, sonoma:        "3ad542e31fe1dc076f638d77aa149d5a802b62bb53c8927fe23ccbae8afaadaf"
    sha256 cellar: :any,                 arm64_linux:   "4a5e76ff039d372abd5f1c879c90bab99a459ef0c06b0ba9a58392f298832697"
    sha256 cellar: :any,                 x86_64_linux:  "48d01151cb704ffbd2062cf56b760068595c6ca8ced0c6e582ea4618f3f6dcd0"
  end

  depends_on "go"

  def install
    ENV["CGO_ENABLED"] = "1"
    ldflags = "-X main.version=#{version} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"vet", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vet version 2>&1")

    output = shell_output("#{bin}/vet scan parsers 2>&1")
    assert_match "Available Lockfile Parsers", output
  end
end
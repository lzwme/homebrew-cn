class Vet < Formula
  desc "Policy driven vetting of open source dependencies"
  homepage "https://safedep.io/"
  url "https://ghfast.top/https://github.com/safedep/vet/archive/refs/tags/v1.12.22.tar.gz"
  sha256 "bae75efe717d7c111fc77b0302e363438d0e555eaf3e36cbfa5b16a71073e66b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "242ec4faa1b46219af055bb8957320fa6e38f5c8c57a41b30f6c3f6c7c48028e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c8cf1253f713abd38b770dd4655030b70e5455a365bcf1cd79ac6837d41b1bb2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "695a0c5ab06980938e2edafde6ac0bafd9683b96193e5e246b7ab1fe72efea64"
    sha256 cellar: :any_skip_relocation, sonoma:        "f6ad48b152bb9d97dc92a0b2c51823db22de56eeb3eb61c1dcd52134fda45c94"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2af15fc5142300d9fcc858886b565c62348bf86cb148eeb8a396a543989cff60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de8f73135c8bc65890039c137e6dd2d3440b3fe825868e09ba4087487112fbb8"
  end

  depends_on "go"

  def install
    ENV["CGO_ENABLED"] = "1"
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"vet", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vet version 2>&1")

    output = shell_output("#{bin}/vet scan parsers 2>&1")
    assert_match "Available Lockfile Parsers", output
  end
end
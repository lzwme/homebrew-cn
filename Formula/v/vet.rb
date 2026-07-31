class Vet < Formula
  desc "Policy driven vetting of open source dependencies"
  homepage "https://safedep.io/"
  url "https://ghfast.top/https://github.com/safedep/vet/archive/refs/tags/v1.18.1.tar.gz"
  sha256 "fb3c0e9c72394b25534bb3b26aa85da5484f43ba0924068cfc47ca4ff4cf36a5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "620b9dd7f4d8e491cc5b50c9eb98f491509b67cc059837b180a38a6efc4c5b9d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "096d3070df3b7b81d494b45fce41026350e26951565da29ccfde672a0f022664"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "36550246df4fce8e2e50f5ca8ab96add449616e9717fc987e9b91ccfcca9112d"
    sha256 cellar: :any_skip_relocation, sonoma:        "3a26fa0d90bf62e7a088521d287894ccf6e121ac9cd0e89a7846d6c4832e553e"
    sha256 cellar: :any,                 arm64_linux:   "4b225f414c9f12f548b619969bea4b61ae6c7848533df721e31d1b3e93d0cb42"
    sha256 cellar: :any,                 x86_64_linux:  "e4c808155a9bb45f4beae8e02c5da1187d75743772e9a910ae432e1b3ad56f92"
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
class Vet < Formula
  desc "Policy driven vetting of open source dependencies"
  homepage "https://safedep.io/"
  url "https://ghfast.top/https://github.com/safedep/vet/archive/refs/tags/v1.17.4.tar.gz"
  sha256 "6b7d59be01667259ab4b446c5db904b6afa46b296214310a306505c1699c799e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "68693e3d9aa2d38744d4f79c87f46a4f66300c06d0bf6e42a4ec2c4dc1164d12"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4b1a3eda3b254bb093468126b8c9e45bfd4de6f051f8305c5824d1c006139dbd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eba9afb0496ffdc31c4ebfe90193a7933559ec451751012a5cf447080e6025ce"
    sha256 cellar: :any_skip_relocation, sonoma:        "69d31de505a0bdc2b929eee82ec1a30fffbe6d395a9c778d6034b3b741b62166"
    sha256 cellar: :any,                 arm64_linux:   "22714b2e176394ebf73e932aafc54b9ba7f2c55ce21df924191b24d6860f6424"
    sha256 cellar: :any,                 x86_64_linux:  "1fbcf9c94ddf549e5bd98a33cddbce112290eae6fab505cd3917b73ad7658681"
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
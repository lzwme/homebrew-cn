class Vet < Formula
  desc "Policy driven vetting of open source dependencies"
  homepage "https://safedep.io/"
  url "https://ghfast.top/https://github.com/safedep/vet/archive/refs/tags/v1.12.4.tar.gz"
  sha256 "256bfee1cd12f99344980c195bdee77f8e48e9f006e3a52c6609c3574adb20e2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "86ba16e1d8f79f91adb988095ece71d269a05833afaed68913cf53f237e00759"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "599e16676ce55162fe3d9475974b08f956b1536703bfc1706c19bf0cecebe5ad"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "eb5d365ed42526013776d1d2041d7da05f65b67cae41516d1cc13ba72b3eacdc"
    sha256 cellar: :any_skip_relocation, sonoma:        "2a14ccf01b9f21839336e5592c38b79de6c6cf518f4f925934f8a55b06d72c74"
    sha256 cellar: :any_skip_relocation, ventura:       "a428d862d146c3817cf7597485b61ea216f016bd8798d70f3aad6281a10d0eff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dc84b970e9425e1763edd70a1e10597d4923d31d80b105d5f2fee42af512aaf4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff89339f5fe3415c9456c893a6d63d8e05e0ada5082e94ebb8f5b0ec68004b5c"
  end

  depends_on "go"

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"vet", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vet version 2>&1")

    output = shell_output("#{bin}/vet scan parsers 2>&1")
    assert_match "Available Lockfile Parsers", output
  end
end
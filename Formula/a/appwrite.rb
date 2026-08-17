class Appwrite < Formula
  desc "Command-line tool for Appwrite"
  homepage "https://appwrite.io"
  url "https://ghfast.top/https://github.com/appwrite/sdk-for-cli/archive/refs/tags/27.0.0.tar.gz"
  sha256 "612d8df2b6c2c2f626845a3e10e73f90033f6b3924fca2b0545c927adfa5d93d"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "06b2643742dd3c4b56a85a6289e25f070e9d3f0ecca9fab9bf1bba558979e2ba"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "06b2643742dd3c4b56a85a6289e25f070e9d3f0ecca9fab9bf1bba558979e2ba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "06b2643742dd3c4b56a85a6289e25f070e9d3f0ecca9fab9bf1bba558979e2ba"
    sha256 cellar: :any_skip_relocation, sonoma:        "98b0a17846c362ff84d5e0e0aa021c0e5597f2fd36b3d3c95dbd819d56a6b608"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2d0a86f52c630e39011250e4a26943890d4779c2333d5808c3de8e3e2c8e0bfa"
    sha256 cellar: :any,                 x86_64_linux:  "f2bf45ba5e8ad4a8f21c36500ba732497e667f84917527bfe83483f894d1b338"
  end

  depends_on "go" => :build

  def install
    # https://github.com/appwrite/sdk-for-cli/blob/4399a3321898f40cf982acbd4859d506c9d4d9f4/.goreleaser.yaml#L19-L22
    system "go", "mod", "tidy"
    system "go", "build", *std_go_args(ldflags: "-X github.com/appwrite/sdk-for-cli/internal/app.Version=#{version}")

    generate_completions_from_executable(bin/"appwrite", "completion")
  end

  test do
    output = shell_output("#{bin}/appwrite client --endpoint http://localhost/v1 2>&1", 1)
    assert_match "Error: invalid endpoint", output

    assert_match version.to_s, shell_output("#{bin}/appwrite --version")
  end
end
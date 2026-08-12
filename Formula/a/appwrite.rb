class Appwrite < Formula
  desc "Command-line tool for Appwrite"
  homepage "https://appwrite.io"
  url "https://ghfast.top/https://github.com/appwrite/sdk-for-cli/archive/refs/tags/26.0.0.tar.gz"
  sha256 "f7c34a71048207a74ceab9168f11f34e6b57f57d2ca58c6d0bfe1b96ebc332cd"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "396b36071f43209e96ff875ebcaea557d1bbe2a172939da7db524bfcf804e0bb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "396b36071f43209e96ff875ebcaea557d1bbe2a172939da7db524bfcf804e0bb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "396b36071f43209e96ff875ebcaea557d1bbe2a172939da7db524bfcf804e0bb"
    sha256 cellar: :any_skip_relocation, sonoma:        "b18bf984d7af282f6162f916d27864ca14e43819cef9e95236d989bbd03196ef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f6982729841d5e07dddd3067849d83c5178c6a4b9aa546dc38d53f49c3dbc3a4"
    sha256 cellar: :any,                 x86_64_linux:  "62a177d2124a194f9b0826403e7ac2bc425ae11499244253f9a78e22dcbd1ebd"
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
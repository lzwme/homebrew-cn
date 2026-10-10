class Appwrite < Formula
  desc "Command-line tool for Appwrite"
  homepage "https://appwrite.io"
  url "https://ghfast.top/https://github.com/appwrite/sdk-for-cli/archive/refs/tags/28.3.0.tar.gz"
  sha256 "725a8b95cbdddbadb113012fee201176d78e0b1eb1cb125626129d77cb7b41d3"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "82f3b5b9b3430b8dd4be641d8db09802c424fcfa43f43988ff20624ccfb18a43"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "82f3b5b9b3430b8dd4be641d8db09802c424fcfa43f43988ff20624ccfb18a43"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "82f3b5b9b3430b8dd4be641d8db09802c424fcfa43f43988ff20624ccfb18a43"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "89f80765ea13eadecb6f9df5df8897d93a98ab1fd50c1fb46f5a3b503040a8eb"
    sha256 cellar: :any,                 x86_64_linux:      "02bae7fc98ce8e9dfe4e086394066ef328af8077b8d415f986862d9cca4ca4ee"
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
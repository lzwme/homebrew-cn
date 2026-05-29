class Oasdiff < Formula
  desc "OpenAPI Diff and Breaking Changes"
  homepage "https://www.oasdiff.com/"
  url "https://ghfast.top/https://github.com/oasdiff/oasdiff/archive/refs/tags/v1.17.0.tar.gz"
  sha256 "f7addb69bbe87b66f0886b27c2fe33cfc20876fcdd798574346dd4973a08fcfe"
  license "Apache-2.0"
  head "https://github.com/oasdiff/oasdiff.git", branch: "main"

  # Livecheck against GitHub latest releases is necessary because there was a v1.6.0 release after v2.1.2.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "171293daa0e8469f2ab5e290f1af3c58af09cf823620d2ec43bfa8fa0215dc9f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "171293daa0e8469f2ab5e290f1af3c58af09cf823620d2ec43bfa8fa0215dc9f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "171293daa0e8469f2ab5e290f1af3c58af09cf823620d2ec43bfa8fa0215dc9f"
    sha256 cellar: :any_skip_relocation, sonoma:        "bd33af9a3d08c7249a1c977e738a49609e09e5ee26c278387f77a006b5d7bf68"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ec2b2cc691471504a489bde1c5222f9604ecd8d68d06ab449f1d4e5249539a56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de7fa033c3aef645a7deb9dcde77724b9bf6ee1016864ac49d65cf7dcbb2f9be"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/oasdiff/oasdiff/build.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"oasdiff", shell_parameter_format: :cobra)
  end

  test do
    resource "homebrew-openapi-test1.yaml" do
      url "https://ghfast.top/https://raw.githubusercontent.com/oasdiff/oasdiff/8fdb99634d0f7f827810ee1ba7b23aa4ada8b124/data/openapi-test1.yaml"
      sha256 "f98cd3dc42c7d7a61c1056fa5a1bd3419b776758546cf932b03324c6c1878818"
    end

    resource "homebrew-openapi-test5.yaml" do
      url "https://ghfast.top/https://raw.githubusercontent.com/oasdiff/oasdiff/8fdb99634d0f7f827810ee1ba7b23aa4ada8b124/data/openapi-test5.yaml"
      sha256 "07e872b876df5afdc1933c2eca9ee18262aeab941dc5222c0ae58363d9eec567"
    end

    testpath.install resource("homebrew-openapi-test1.yaml")
    testpath.install resource("homebrew-openapi-test5.yaml")

    expected = "11 changes: 3 error, 2 warning, 6 info"
    assert_match expected, shell_output("#{bin}/oasdiff changelog openapi-test1.yaml openapi-test5.yaml")

    assert_match version.to_s, shell_output("#{bin}/oasdiff --version")
  end
end
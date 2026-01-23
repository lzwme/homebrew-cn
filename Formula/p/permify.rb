class Permify < Formula
  desc "Open-source authorization service & policy engine based on Google Zanzibar"
  homepage "https://github.com/Permify/permify"
  url "https://ghfast.top/https://github.com/Permify/permify/archive/refs/tags/v1.6.1.tar.gz"
  sha256 "f48f27842638bda50e066ad970f6ef50ada6593189b41089c5584609f34d6c1f"
  license "AGPL-3.0-only"
  head "https://github.com/Permify/permify.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4cdbecd4f5139e4a65c9ea36c8837fb7338d9b90597ee670210fef70a63739b7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f5bf2344f2a4bd6c91781de3ac80ea00e0b5150e8d7218b1805712311c7098b8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5a319aedc2cc6df8227e4e17ac99fcb9c6996ea2d3183f170002eff9ebe663ea"
    sha256 cellar: :any_skip_relocation, sonoma:        "af560cf639f6c18f980022bc0f3fd2c5fc47f74aabb92c7cde8f17676bb737a0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "478b53a2d4d721e3618d923fe3cb058ce42e84a0017366a8b359a38d3d9fdd70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "07b0d8d6f247e2afd39d51eb6befe8f6f322c1c72e14838e3f99a34bae3c9310"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/permify"

    generate_completions_from_executable(bin/"permify", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/permify version")

    (testpath/"schema.yaml").write <<~YAML
      schema: >-
        entity user {}

        entity document {
          relation viewer @user
          action view = viewer
        }
    YAML

    output = shell_output("#{bin}/permify ast #{testpath}/schema.yaml")
    assert_equal "document", JSON.parse(output)["entityDefinitions"]["document"]["name"]
  end
end
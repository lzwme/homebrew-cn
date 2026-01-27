class Permify < Formula
  desc "Open-source authorization service & policy engine based on Google Zanzibar"
  homepage "https://github.com/Permify/permify"
  url "https://ghfast.top/https://github.com/Permify/permify/archive/refs/tags/v1.6.2.tar.gz"
  sha256 "ee8bb3b65cedf920e71e9dd5347faf1c6445b138ab9233a266a96bf2956d7c83"
  license "AGPL-3.0-only"
  head "https://github.com/Permify/permify.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "91d7634dd3c05dc87a11d4b8783491f66b61a9c5eba3bbf2623b6786dba52ba1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "88329e4244f8f3ec998c38f5e7317170b24f86070d7271af32309163f32fd8a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d0970c3e669806dc8fd27ec9edb0b478c4d3ca264f4e8295c4e5b509a7ff0c5e"
    sha256 cellar: :any_skip_relocation, sonoma:        "1d574762f42aaf8b2d232b2dc8b3ed785d8695a52221f433500783c883259cbf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dcd92b6e31eea396aab32b6419a1ea1a9913dcb1dcbbb557c111961622bd59bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f2db4b9d46286b3a370ec114f488fef54d151e22461a3147e9bdd8fbf5a703b8"
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
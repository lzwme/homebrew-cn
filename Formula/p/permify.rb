class Permify < Formula
  desc "Open-source authorization service & policy engine based on Google Zanzibar"
  homepage "https://github.com/Permify/permify"
  url "https://ghfast.top/https://github.com/Permify/permify/archive/refs/tags/v1.6.7.tar.gz"
  sha256 "90828985ba6a6331cc04e609f21ff476ae8b97f2787c7bb678b9d571b84a0a74"
  license "AGPL-3.0-only"
  head "https://github.com/Permify/permify.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "32bfd9c8a0e7cbc78ebe330ef82088dfb6764c0e3496b38492c70dddddd8e78c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "499f6f967d4a3d637d0d9a5a12891347f499b4f8a61c5f48a5e57b42ac371104"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "24abe154068b044a7ad85e25fdf575b74cacad0b2810289df742306e91a7e64e"
    sha256 cellar: :any_skip_relocation, sonoma:        "381ea596ed16b8c1c1e8c0fdc23cb0391de1bd19f3d9e44d9031ac020ad86b95"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "905db62f4f26ac84e9c90533e4322902de079b10e34458c6952c2621d7d0cf63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a66bd34fe08addba9e8bf6662bab4ff4348d1c327e93f387d47c5c0b24fd8424"
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
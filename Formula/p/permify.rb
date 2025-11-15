class Permify < Formula
  desc "Open-source authorization service & policy engine based on Google Zanzibar"
  homepage "https://github.com/Permify/permify"
  url "https://ghfast.top/https://github.com/Permify/permify/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "7fb86f1a01fb41d2a5b2a0da9360a4832a5c04e00c2000a18321ddc99c3763ea"
  license "AGPL-3.0-only"
  head "https://github.com/Permify/permify.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c114f07bdf311dc956625a0d84c21bd4d2900672e9c02127f79ee52480c3a414"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a4ed2ab38474800411f43988cfc7e1dfc2b626f95ff62d930bdfb016c1dae43c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "54b9b65ef23813c52399cd707b70162593f4628d06d2193fde7de038cd1e0911"
    sha256 cellar: :any_skip_relocation, sonoma:        "9eea2fcbe41fa03fb5bb1b73f6cbc5d4d9d2093daaaadf98c28ca17f6ad2c67f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "089fe36223f285b86228e1f9efc8e000e03066c8276ff4ae8f10be7f1949f517"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "02fa4bebec283bc8a7d036433ccbda7945894a6b674f06bca470ce678daa5325"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/permify"

    generate_completions_from_executable(bin/"permify", "completion", shells: [:bash, :zsh, :fish, :pwsh])
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
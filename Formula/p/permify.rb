class Permify < Formula
  desc "Open-source authorization service & policy engine based on Google Zanzibar"
  homepage "https://github.com/Permify/permify"
  url "https://ghfast.top/https://github.com/Permify/permify/archive/refs/tags/v1.4.9.tar.gz"
  sha256 "c1419492151dca5a2fe5f11a51ca50147ab068c2d860609b17e8ad060198e359"
  license "AGPL-3.0-only"
  head "https://github.com/Permify/permify.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9a0c4e53fe54fb821bd6b81cb2639382280924f1f6bf3e64b02ae41615f2f2f1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c5f8b519cce4f36be1a623aa0a95dd68dcb4bd790e1cb79644644d1342e44eec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7d40f2cd662a5c7d210eda4153489951ae0024d19561c4106d9a0b6e2afa6eff"
    sha256 cellar: :any_skip_relocation, sonoma:        "511c72f738a1a9b3519a94712c7e71ad37573b601b2f3b8599ed31c18ae0fd30"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "925e023f4100a87f24b9a1b51b75186f6a98d6e5b6b474dd1e0edaaa37ed9260"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ea13fd525771266f00f40f5e626b80e93cd95900eb95b1097e2dffc232dd4c7"
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
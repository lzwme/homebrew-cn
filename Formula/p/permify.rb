class Permify < Formula
  desc "Open-source authorization service & policy engine based on Google Zanzibar"
  homepage "https://github.com/Permify/permify"
  url "https://ghfast.top/https://github.com/Permify/permify/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "4ed73d1e1b8bd50727e21897ea703fe1262444e4c70b9e5f72dcb34a70cf1162"
  license "AGPL-3.0-only"
  head "https://github.com/Permify/permify.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "539b08047e839885b361c1801eb2defe360242e660efc40fc8fc338750bbf866"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7d4aaf061a1f505bbbe274be6372f0d48f5e8d4dd23885d4e5b03a011d2b3c4a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "771487ee252857c1125dfcd9c164b9d6b189a207f8fcc670c5e120a7761e4f68"
    sha256 cellar: :any_skip_relocation, sonoma:        "b727b424178fa1f95fa134c78521a5bc72821a4e72f14a4194d732ebf473ab8d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dba14fbb98530e49c2181bb986d8de60f5a6bebb53459c2653ce62d26e38584e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "30c884aab4b6cef3ad370b4b5a62248bf88a4f43b49253defae180b04e6add7f"
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
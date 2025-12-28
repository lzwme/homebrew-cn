class Permify < Formula
  desc "Open-source authorization service & policy engine based on Google Zanzibar"
  homepage "https://github.com/Permify/permify"
  url "https://ghfast.top/https://github.com/Permify/permify/archive/refs/tags/v1.5.4.tar.gz"
  sha256 "06be72fe53e4853743ab7113dc685cd3e1bcecbf8850880f81856920c1937110"
  license "AGPL-3.0-only"
  head "https://github.com/Permify/permify.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6da7d2570ed14fdf3cf21cb24290bc464b2a7ef0073c4c60a51526135688ce2b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0b4e5375d724ca9f0b1e8cafc1d535011526a527ca9f329feebff4290ac16b05"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "637b1702a8a877117cb6602d37dfee04fbcaf7d81cac158488e1af7f1b06c6ba"
    sha256 cellar: :any_skip_relocation, sonoma:        "04920f518edc7a4d70b8f38f63caebaf99497351c6136b0a7d37c1201f628e0a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b97266c456a2d9ec79989e83bdbfcd36c87bf1d1a71e09a460b1ffb2b2aa78c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "971c42a8b4dc275173d2e3a6d17da8019ef1a061629d514522a4436339d186a4"
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
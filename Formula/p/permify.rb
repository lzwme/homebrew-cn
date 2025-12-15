class Permify < Formula
  desc "Open-source authorization service & policy engine based on Google Zanzibar"
  homepage "https://github.com/Permify/permify"
  url "https://ghfast.top/https://github.com/Permify/permify/archive/refs/tags/v1.5.4.tar.gz"
  sha256 "06be72fe53e4853743ab7113dc685cd3e1bcecbf8850880f81856920c1937110"
  license "AGPL-3.0-only"
  head "https://github.com/Permify/permify.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2bfa88c22433d81bb6799628b86ffa83dba1e5fbe71aacd4ebb1a964a5d54672"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "00641a1b86f4a75d7bab9930f6b49f2186dfe65266aac9c4d132392fa02be5a4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "071b104c7db2a94bb7b7675d59194c6f7b8fb55244c37a23cbd38de24dbbce56"
    sha256 cellar: :any_skip_relocation, sonoma:        "6916af6b708fa71a1e8d4f1e0c5ea5118eab8a52adccf1d81837d734190244ef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f5f41298ea29c79474b4b27743b44ba9ec04d27ceef3d748abd39ec1d83c8e86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b4c42d1ba88d0a755aaa5927ef68a135d605c9961fa0232bce7e0c6c34259df2"
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
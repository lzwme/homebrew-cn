class Permify < Formula
  desc "Open-source authorization service & policy engine based on Google Zanzibar"
  homepage "https://github.com/Permify/permify"
  url "https://ghfast.top/https://github.com/Permify/permify/archive/refs/tags/v1.6.5.tar.gz"
  sha256 "e98e516629183b6b00150a28b582304bd7b14ff76bebb4dc11db503540db3c38"
  license "AGPL-3.0-only"
  head "https://github.com/Permify/permify.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6d8b86fce73b29bf16759c2e9480b49d7d02aa2554530409994f65601b55d6b3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d1f0c84a0a30bad55fd4735f07aa32bd9b1c534a0db6e9c562d388656f11d429"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "73c2bf17c22a6f8f676e345c6e7c41bdb7c4a13594cddb0dfa29e7638bc25ada"
    sha256 cellar: :any_skip_relocation, sonoma:        "994c2f4a02b918d479e3061009018fcf3d3308cd5ed2e731b9b067ec7d4bea4f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ef74f5500b434a7279e79111a9d77d12bf1a9e7b6e0abee1a48de40753457df6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b51e531f006ef5f875e7d506f9415389d143ed5f153cf919237bab9291fdcffc"
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
class Permify < Formula
  desc "Open-source authorization service & policy engine based on Google Zanzibar"
  homepage "https://github.com/Permify/permify"
  url "https://ghfast.top/https://github.com/Permify/permify/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "4d524431c9d8eb9c79f611589e0f8ed11c4a27f234a6914f2ea2f10e49efdc26"
  license "AGPL-3.0-only"
  head "https://github.com/Permify/permify.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9486b09f80b5a7f0b7fd2a82837145ca34df6d9540e9a948cdebf9a98cc2b00b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "334f2d5b7598193c34afc95fa70e2e7db8dcd9e1fe5066e113ebcfeb3826522a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3d4fb6735af5b84e3e38d10562a4911a6fdc8c182e1cec6a401d0d18e5d4ee81"
    sha256 cellar: :any_skip_relocation, sonoma:        "3db83c581349bbe7e077ff43d3e68af8e78562dc1c2f3205dd61472cc3b05768"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "10afd688888904155beb6a1c4b80815bbc34366c19896c1f111c1c4c064ad3f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "923da33fd2c1cbefb5361ccc36fa1be7373b7d4b02d551fcc8f74c8da832cb0a"
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
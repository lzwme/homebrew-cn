class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://ghfast.top/https://github.com/rorkai/App-Store-Connect-CLI/archive/refs/tags/1.2.5.tar.gz"
  sha256 "763a2e144d6b0ada4b545062ecbce146383333bf006a1af50b1c8a0b24d76b2f"
  license "MIT"
  head "https://github.com/rorkai/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "25705c72042a7962ddc0d92921a73dd80f1b62776cfd809818a059f3cf049ef0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "27ecd720a8196705816ee1eb6e3a68b577b5b9c12806fea59c62dafa3552d913"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1892210e9cc94ae0088a074c9eb441be99fd67e91933f9911dd239c82e22228f"
    sha256 cellar: :any_skip_relocation, sonoma:        "1c2d46effa2db814dc98acb45d67dab22b40897a527bf492f19bcb9f97b72faa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9cbafdfc070292f8b1fb911c29c2d257e26315d1fd9f05982c7f936e6716568b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "09270a1f6d36e4781e43fba0d444df246d1a66052dfc3ccbfb422916d26b49f0"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"asc", "completion", "--shell")
  end

  test do
    system bin/"asc", "init", "--path", testpath/"ASC.md", "--link=false"
    assert_path_exists testpath/"ASC.md"
    assert_match "asc cli reference", (testpath/"ASC.md").read
    assert_match version.to_s, shell_output("#{bin}/asc version")
  end
end
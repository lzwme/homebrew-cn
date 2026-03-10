class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://ghfast.top/https://github.com/rudrankriyam/App-Store-Connect-CLI/archive/refs/tags/0.38.0.tar.gz"
  sha256 "63036d9e944594024b165be808f46d65b52a5c1cf618a31efaf50e2c5349fef0"
  license "MIT"
  head "https://github.com/rudrankriyam/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ab4db2cb8aff0a2cbac26d9a32456731dc24d789c5de24c5c11264b3feda8735"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e21a57f2ab73b9bef6100a8e9606b5b52bc4fa43ca5d4e8f756affd217386747"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a513875bce83b85a2b7247fca7107daf6bdcd10f7333221e33ddebb665483d6c"
    sha256 cellar: :any_skip_relocation, sonoma:        "4f1b8dac62f07453cc086be52416efaa390569c5cda3f8efed348e41a1bd279a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c4dc4a58e9a2696b71e15072c5419343d391cccc3a10e9aa956262f91a6df466"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ad197b5135e03c4624a25be25812950e4a3c1ad4649ddc3b4579e797b67089ed"
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
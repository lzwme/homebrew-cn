class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://ghfast.top/https://github.com/rorkai/App-Store-Connect-CLI/archive/refs/tags/5.5.0.tar.gz"
  sha256 "85cad0317564c1f2015d79efdce25c88cc88474a54a1cf1f1eb5d57401196795"
  license "MIT"
  head "https://github.com/rorkai/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "60ce484fae689524874051102d2b290c56a0f2d07d68cd79b4821888e3bdb1cb"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "dd9bad038599dad88f325fd4282ee9a7b3a3b66ea6e49b5790b4c4275087eec0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5264a3df63059168af1d2b58d002300816de12087b29fdcec8e0f9430950f708"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "404a2ae997cb43d3ef3a0fabf5c5a15caebc6bdd6f3573be882b7b8f691e83ad"
    sha256 cellar: :any,                 x86_64_linux:      "f3ceae1d10fbba5a0c7959d91be7d5428b16b0e8a8312cdb4d283861dea2d051"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X main.version=#{version}"
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
class Scw < Formula
  desc "Command-line Interface for Scaleway"
  homepage "https://www.scaleway.com/en/cli/"
  url "https://ghfast.top/https://github.com/scaleway/scaleway-cli/archive/refs/tags/v2.60.0.tar.gz"
  sha256 "744deb8a1a28c90b0d0e34cf06f60f40638f0ee17d55ba6dcd803be410baddf6"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e3e90bf5a0ad3e8a73a572e58e2b035dd0d024b3e4d71f71683f6292722ab2ab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a2d213badc79a17e44146addcfcf822e3718e7bb9e33e6debea70b98fdfea2e7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7a77eed2527b93a12c4f2cfd0d78847970e5078d42e27f72e83814a228d53cfa"
    sha256 cellar: :any_skip_relocation, sonoma:        "a478e28fe2fc377f2797ae47819ea7946d651dad070e095ef9828e3a94ac8362"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b11a176ddd54549d8c96d775d477eea7f1324c7d27838529b25d974c6445f558"
    sha256 cellar: :any,                 x86_64_linux:  "a1e2315826ee52d5a47fd5f421bb55b1e8fcce3e917ab2bf8bc9b2e56e1b0ea4"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.Version=#{version}"), "./cmd/scw"

    generate_completions_from_executable(bin/"scw", "autocomplete", "script", shell_parameter_format: :none)
  end

  test do
    (testpath/"config.yaml").write ""
    output = shell_output("#{bin}/scw -c config.yaml config set access-key=SCWXXXXXXXXXXXXXXXXX")
    assert_match "✅ Successfully update config.", output
    assert_match "access_key: SCWXXXXXXXXXXXXXXXXX", File.read(testpath/"config.yaml")
  end
end
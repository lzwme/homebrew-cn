class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://ghfast.top/https://github.com/rorkai/App-Store-Connect-CLI/archive/refs/tags/4.4.3.tar.gz"
  sha256 "e50c0c1d3b9a6b6ee88a23b48dd26c79186dd088e8042fc1c7d1b8e706bc4561"
  license "MIT"
  head "https://github.com/rorkai/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ae0b2ddf0d7182917ebf9adb74a6e3d1ae34cc43b78fe4a530a41ff7c8ee4b5c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "68f7c4693c8a41aa5918d5eb3fcb6f99ab4bae7ad430867c18f71bb87bb61f63"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f0451f0900eed2762b84a5484b7f2d1a0bad4d631a56cccd19e33dc16f931a2c"
    sha256 cellar: :any_skip_relocation, sonoma:        "347afee651fd7099b142c57efbbb7897761d51e3b206f4ae5d0e4437a7601af9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "860e102fd461c542c586f9eddad4ac2f21520d863a29f226d5929544e60dde31"
    sha256 cellar: :any,                 x86_64_linux:  "b1953a24f54865bf81dd12399d45f48586a10cf7fd19745372d11f840af3cd90"
  end

  depends_on "go" => :build

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
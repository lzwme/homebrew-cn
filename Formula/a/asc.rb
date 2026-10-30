class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://ghfast.top/https://github.com/rorkai/App-Store-Connect-CLI/archive/refs/tags/6.0.0.tar.gz"
  sha256 "f7e70ce8d5ed6126efd999b548b95efa9299e194569e8e99a7b3f9d921f2b718"
  license "MIT"
  head "https://github.com/rorkai/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "383b48813899828366ced0deb2f0e8392df92191509e3c17e988ac6732b6ae9a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f7129a4372c7a672ca2d0c91fecc5b269a587eb8a2df04bb2df0c2957fa9658d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "706f071d1173ba186e44d3c639e9da5e9abfc5676cb6d0310b63f650681b3607"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1bfa5f3539d17ac2f6e451cbf19f7474aaa7a5084c3c9b26cfbb80cfd7078d07"
    sha256 cellar: :any,                 x86_64_linux:      "3364cd76f8db6ff1c825af904d0cf80adb54078fbb8c61ecfd44344c76c9bfc9"
  end

  depends_on "go" => :build

  conflicts_with "asccli", because: "both install `asc` binaries"

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
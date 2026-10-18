class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://ghfast.top/https://github.com/rorkai/App-Store-Connect-CLI/archive/refs/tags/5.15.0.tar.gz"
  sha256 "c74c89b59b3b72005ba5f3de3317574cbb9ea6b2d8f9566bd3b47a670792de1f"
  license "MIT"
  head "https://github.com/rorkai/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5fec43fd95a47f61dc03ac8fcd2122df2e4f03f017014ebd283e234644e1f2f5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "07e154395d6c934c388c680811fb4147fa6fe38da95f1d56033e1b51349aa355"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a3814bbad70928616b843164586cbf11eb99f6e312b5c82cb3214d1aa0e46ab8"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "2fa777afe211b8d04358fd661bfe31b24ab62ad5688d2c1d2f4088e564b01cda"
    sha256 cellar: :any,                 x86_64_linux:      "5b2b981bf0f53c05b4b0cbb30ddf6c637bb45381b4ba552e288de74bce72800f"
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
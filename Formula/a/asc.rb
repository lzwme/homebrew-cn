class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://ghfast.top/https://github.com/rorkai/App-Store-Connect-CLI/archive/refs/tags/3.1.3.tar.gz"
  sha256 "20973002c2fd4dd1e2ab2b2e7a856286da4081ac1173a8616df52e42a1fcb3bd"
  license "MIT"
  head "https://github.com/rorkai/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "20fe82ca0f64d64c025dd4c785a261f7217eb6983f05177f4a8ee68d33195e76"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aafe8356840d585bf86b48567a5e2ea6476c7c363834dd46024b169eb94b639d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0da5740373fc7b88305abf5ee995b56018beb004a6ecbd848af661453fbdcdb6"
    sha256 cellar: :any_skip_relocation, sonoma:        "51d10ed2194d0dc8f49275f3f4ec40cd1885605919837b137372c70d4c2b4839"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aa1905143bfc19c5ba1e52d6bbfe337602a49e83b0670a5d8397125c79d14f98"
    sha256 cellar: :any,                 x86_64_linux:  "f445984fe565e883da59fdf0b04d66092f807f9325d788049431a6303fa382ce"
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
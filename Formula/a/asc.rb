class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://ghfast.top/https://github.com/rorkai/App-Store-Connect-CLI/archive/refs/tags/2.8.1.tar.gz"
  sha256 "7183fcd0d727c4c0a72a8b6610ef5eca1a3e3a95ceb83e85db8183cad692f247"
  license "MIT"
  head "https://github.com/rorkai/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6fa598244d3004feea187eb64145ac530e4e4db314a5e1ff45447d80ace08b2e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a7b70007bb9dd8ae49b7c5ebd4534f2a58f1ae3bd730b43e438e46285be6bf25"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7707b79d18820b55ada9d4daa502f884e54ce33f3b4dde9328a431514aca0944"
    sha256 cellar: :any_skip_relocation, sonoma:        "2ef2ec5c41f4394d321187236d7ff410e0819b28a4e4b8a1fec54b2809c29512"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6e0037567174ee746c6275aad9be57ad0cfca53c10a16e75447c709f13498a4d"
    sha256 cellar: :any,                 x86_64_linux:  "af975cebd30259f28f7e7e5d2afc3c7b5c097e2f02f3ce98c8c0481411187e9f"
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
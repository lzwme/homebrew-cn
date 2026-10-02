class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://ghfast.top/https://github.com/rorkai/App-Store-Connect-CLI/archive/refs/tags/5.9.1.tar.gz"
  sha256 "4440f3e65faef9b9cb66dc61eaf7c3364586fe6767f41b9f66e5021920c71a31"
  license "MIT"
  head "https://github.com/rorkai/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "02598d4412724c785c14ae285e317ac361b9ca68c52e8930ba67ca1792115e9d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7bd896059e2ebd967bf1f3d5231d06313b2ddfb341c716aa43034c5e859278a4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "da4b2bd9a049e7a122491bad608137441ae9daada5d7c1048b6a163028000e6e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8e8e0417dc5c2fbea1b04ff2e8ca49706d05701853ca6d8dae8b6217b056d390"
    sha256 cellar: :any,                 x86_64_linux:      "8ead8fb09a838645522dbfc174fc7375a90ad903c1914d755ce2df134c3c0258"
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
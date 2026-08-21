class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://ghfast.top/https://github.com/rorkai/App-Store-Connect-CLI/archive/refs/tags/4.6.1.tar.gz"
  sha256 "d142511027867b5746918d216161f1857fc045f4d8b82da52745a51770ae7f2c"
  license "MIT"
  head "https://github.com/rorkai/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "17ed7a9eb885de3671ed07fa2de3beed41682aadb11728058a9c0cd647b02254"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6c9d593bcae28b980363ba1ffa9bc3cd4a8336b42f412ae2d1e20778f789f699"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1cf0d8298a29823a08fc91d34d310788701a4d780ad5282e85db5ca9b30d3ed1"
    sha256 cellar: :any_skip_relocation, sonoma:        "9b24f0434f75a3ea2c7521d7fa59accf7f9fc2e153bbfa0db855e5c20e3c5dc8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d054789e40c6c76cbe0fad6f8a1f5210ccd8d8f1c789c877cd8305501ba24bf8"
    sha256 cellar: :any,                 x86_64_linux:  "28de65b3d17d39661d8714a99d5b5f28ae6f6b2662a3a58a5cc773ae9202c25a"
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
class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://ghfast.top/https://github.com/rorkai/App-Store-Connect-CLI/archive/refs/tags/3.4.1.tar.gz"
  sha256 "8bd6e617e0615a6e019ff919dd66ca731f8a9dbc7b91691eae9c656d53bc255c"
  license "MIT"
  head "https://github.com/rorkai/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "768d7c5f72777be060552b3a008d737123c574d1a7378fef56364dff7c6480b6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1f20fbbe522854388605d162b55142fd2c56c352180f98827dbcecfc217d3e9d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "19c168b6b2ed497817436ffbaa902795c328134ea9a54a886d900d35c135e56e"
    sha256 cellar: :any_skip_relocation, sonoma:        "a1e692b6d27af847082e554d2bba6126058b47481da5840c59e7fd5f55889b6e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1806a18bac93dafcbe70d4c3eb2c2254f43689e863c07f474026675fece8fe22"
    sha256 cellar: :any,                 x86_64_linux:  "cf7044574ba134dde9d7f757c9a59dde35ad3d620d0f98c3a92d3ca44c288db6"
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
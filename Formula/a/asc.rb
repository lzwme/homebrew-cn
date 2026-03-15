class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://ghfast.top/https://github.com/rudrankriyam/App-Store-Connect-CLI/archive/refs/tags/0.42.0.tar.gz"
  sha256 "4b7d1aa39d318dc2e1b0a334164f09997172fed872bc776e4db5d03fe31d2462"
  license "MIT"
  head "https://github.com/rudrankriyam/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c66bdb3e3900042aed407efd8963519446d30154ea9135022e567bdbd64e0f2b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "68c27e820edc047bc45c116d58704c6cd403af7c7200cad1d93f41438b2b87e7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5428379ab999da1ca309eb518fd4399e669c00d6303df7dd0b1f45441d47cfd1"
    sha256 cellar: :any_skip_relocation, sonoma:        "5a51eaecd90bf7d65b8ac6885988391ef64352afa7f34f0c4686c98880db18fa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "898c446f2a3d40a264452e6d315c4e70702e4605b4b603cae9f3f717ff4050d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b4898269ed94eca0499e6f80b42906cba85430cbd0c27c17960838ae6992655"
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
class Witr < Formula
  desc "Why is this running?"
  homepage "https://github.com/pranshuparmar/witr"
  url "https://ghfast.top/https://github.com/pranshuparmar/witr/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "9f308ff410033b511cd731de52b877098d8f3b4db83382e482e4f84432497c99"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "911286c2ef980616587e6e6c0fa160ef281ea855dc4ffa22eb3a200f422f8465"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "911286c2ef980616587e6e6c0fa160ef281ea855dc4ffa22eb3a200f422f8465"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "911286c2ef980616587e6e6c0fa160ef281ea855dc4ffa22eb3a200f422f8465"
    sha256 cellar: :any_skip_relocation, sonoma:        "d725bd4ec9e23511ed364090bd2453db4accd13f35cdc178aca121f7477d7c91"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d4b95d9cc3538a1647f250906a97fb4f8fad9db82955f1131127c14de5a20c1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e34917685fe10690e096a25f9bc701a788805a8ba5212362519fcf3863a5ad2"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.buildDate=#{time.iso8601}"), "./cmd/witr"
    generate_completions_from_executable(bin/"witr", "completion")
    man1.install "docs/cli/witr.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/witr --version")
    assert_match "Error: no process ancestry found", shell_output("#{bin}/witr --pid 99999999 2>&1", 1)
  end
end
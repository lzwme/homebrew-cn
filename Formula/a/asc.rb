class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://ghfast.top/https://github.com/rudrankriyam/App-Store-Connect-CLI/archive/refs/tags/0.35.2.tar.gz"
  sha256 "26834d31e82945d39d246ba32195ab4954307884d573219758b03e049ef06484"
  license "MIT"
  head "https://github.com/rudrankriyam/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bdc58c3d2491fa9ae52b7754782a7e1615fad84cb9032e24680e26ec7927b43b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1ef1318e38fcaa7b17c067abbe531672bf0b9c946cad1cf3b671f6cdd520fad1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e6e1d33d54020e1f1c3f05a52d51e46d986659d79e15fb104413e38040482844"
    sha256 cellar: :any_skip_relocation, sonoma:        "8d84ec7100edc8b09df0b219a780e3c3c1d3279d36c6f082481ab920f80b717d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "662f3f5a16a88f30efe52733e5915f23414211d22aa8831897ba3e3bfa2ce757"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "990dda3e973dca9b87d2cdb29c7ea01a29a45014746223ef02d7278455ad5b71"
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
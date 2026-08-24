class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://ghfast.top/https://github.com/rorkai/App-Store-Connect-CLI/archive/refs/tags/4.9.0.tar.gz"
  sha256 "d26f78ad3a125e097cf69c29c06f1c4d1f52db93266f311ef30ab399c2ae9c84"
  license "MIT"
  head "https://github.com/rorkai/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5c9178a3267c6f14802f90bfd63c49d450812daa98b1d8e72355352eb0eaf26c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a1e60396259523c23408d090ce41c2ba331a22077ff428e66c7db8d90c7b6ea0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "89335017000c978445467b99a89e539e5da6671660b1757367138e6c52f6615e"
    sha256 cellar: :any_skip_relocation, sonoma:        "845cf48717415b2673de1a5ade4f1a3ddfb16886c868ef05966d976ae5fb8814"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3c8d926540a54c91e0b75f7d07a3b86141b24ef04874d056f54546da54511acd"
    sha256 cellar: :any,                 x86_64_linux:  "52d3fd7578b4171fe339a153fcd3b3f906f1305312f0137d63e975e3927478d0"
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
class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://ghfast.top/https://github.com/rudrankriyam/App-Store-Connect-CLI/archive/refs/tags/0.31.0.tar.gz"
  sha256 "3cb97c0cd1f9a9ad5b04bbf333be7e32a4de0bb2a917c811e3c4a77519aa71dc"
  license "MIT"
  head "https://github.com/rudrankriyam/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "41406e2000b5e2a95a6e1350a62f8ac011b28f987de439f9a69873a8e0276ecf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "28a47ca30783c4011e94cc5ce36aba920764abedc588d90410c4c1839b249c9d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c033888f4d24878dedd2b06937cf5bba46c3ad5598f2f0facaf3e3d6ed464d93"
    sha256 cellar: :any_skip_relocation, sonoma:        "011bace8cca519141dc760297a9b0101709de70a4c24dc381410af6fea86b97d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "31087ad605e68cc23253371455140a544ce306783ea4389854029575e4e8b543"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f11abca5a537a22ae783234ecf2ae9f5cf00cc5d5aa532e737b9608620b438e"
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
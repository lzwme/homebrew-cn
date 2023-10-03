class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com/client_reference/"
  url "https://ghproxy.com/https://github.com/kosli-dev/cli/archive/refs/tags/v2.6.9.tar.gz"
  sha256 "776405a6bad26f61ea81647ebc11daeb8dd95a9ae195cb7f165471ac0aff1b2b"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "03ca8718603f6b5e4e174c34fc7ddf14f3ba9207f0ad98d12b001aa22efaa63d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "380cac2d43ea2e54d5bd67d7f3c7fa93300f24f0763697e6f32b3dd910864be2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1f085dc336692aafffc6790a9993fff3d2dfbe4de68037cb9a589df3f3a0d350"
    sha256 cellar: :any_skip_relocation, sonoma:         "8356e870c9048e6e0e750b5b69ed83343a25fc13d983122c9e1144aa118a35aa"
    sha256 cellar: :any_skip_relocation, ventura:        "071bc487ba2c9c17d9b98aa3f1a9ca0e14147384b18c7107ca47ce337a3dc53d"
    sha256 cellar: :any_skip_relocation, monterey:       "e9a6f2237e107b831884bc78e0f50321db2f713f7950dc4db5f402493ea8962a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a8fcf6387486269c144e7b9a98fc839a2a49da64a2297e97f1546a6c88d9eb7"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kosli-dev/cli/internal/version.version=#{version}
      -X github.com/kosli-dev/cli/internal/version.gitCommit=#{tap.user}
      -X github.com/kosli-dev/cli/internal/version.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(output: bin/"kosli", ldflags: ldflags), "./cmd/kosli"

    generate_completions_from_executable(bin/"kosli", "completion", base_name: "kosli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kosli version")

    assert_match "OK", shell_output("#{bin}/kosli status")
  end
end
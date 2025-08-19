class Ignite < Formula
  desc "Build, launch, and maintain any crypto application with Ignite CLI"
  homepage "https://docs.ignite.com/"
  url "https://ghfast.top/https://github.com/ignite/cli/archive/refs/tags/v29.3.1.tar.gz"
  sha256 "f501ad2737cb24c1d761905caf5592728a2d0b2440e2dde39ef90a082273b8ad"
  license "Apache-2.0"
  head "https://github.com/ignite/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "09e37bf37fe54f64d51de3078a3ebfde3c1474f566e2b0087d4ab109a47692ec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c30b4d2d4c221326ffd6a506d6ab63d636d9b3972427244a1cf1f688c34626ae"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "45b34f9f06fa6488b4b0f1ff198f7a382d4d1651ed794e94dc04e621d52def2a"
    sha256 cellar: :any_skip_relocation, sonoma:        "03baf493774b97e582c543cf457113d851789aefe5ba1a3e03ed601ca445ed77"
    sha256 cellar: :any_skip_relocation, ventura:       "065e961abfaf91b299fbdacc26213a90ef88112cbac4d920fbd4f1cd1fff5bfd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e44aa860b5f3a226414f4ee884f28ff3cc64d147c0cfda92797fd4f3a9878dcf"
  end

  depends_on "go"
  depends_on "node"

  def install
    system "go", "build", "-mod=readonly", *std_go_args(ldflags: "-s -w", output: bin/"ignite"), "./ignite/cmd/ignite"
  end

  test do
    ENV["DO_NOT_TRACK"] = "1"
    system bin/"ignite", "s", "chain", "mars"
    sleep 2
    sleep 2 if OS.mac? && Hardware::CPU.intel?
    assert_path_exists testpath/"mars/go.mod"
  end
end
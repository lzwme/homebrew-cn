class Atlas < Formula
  desc "Database toolkit"
  homepage "https://atlasgo.io/"
  # Upstream may not mark patch releases as latest on GitHub; it is fine to ship them.
  # See https://github.com/ariga/atlas/issues/1090#issuecomment-1225258408
  url "https://ghfast.top/https://github.com/ariga/atlas/archive/refs/tags/v0.36.0.tar.gz"
  sha256 "87ca8bd4719454905dab64760918d705ce400db7d669de987002fac94198c2af"
  license "Apache-2.0"
  head "https://github.com/ariga/atlas.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6500f7010ad91eb04a58600ebc4974660581c5595d88ca00b72bfdc6c8a20be5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c0615f6af8ad01930d2eac26ba4ff40b3d40cc53af2ce86507d2cf3c49af49e5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e2762390d53d71cff30abcd2cb705350d9e4d47876e6fccf851b7236259c5b2b"
    sha256 cellar: :any_skip_relocation, sonoma:        "59b6859af21088f2bbced6247030e19e0ca6c11729bfd3fdb892f54073be69db"
    sha256 cellar: :any_skip_relocation, ventura:       "eb665ce1f423e57bff8c8730d28c1034a8144fb1898dd2897d33b9451df4d8e5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2f8b4e7a0ad3316b174899a06d668446168bc0ca55b6a59442756d47e2ff1695"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "665ba4d09af6cebf751502e6138c07a2d432a55bc2584e0ef8c99c11042f6dd3"
  end

  depends_on "go" => :build

  conflicts_with "mongodb-atlas-cli", "nim", because: "both install `atlas` executable"

  def install
    ldflags = %W[
      -s -w
      -X ariga.io/atlas/cmd/atlas/internal/cmdapi.version=v#{version}
    ]
    cd "./cmd/atlas" do
      system "go", "build", *std_go_args(ldflags:)
    end

    generate_completions_from_executable(bin/"atlas", "completion")
  end

  test do
    assert_match "Error: mysql: query system variables:",
      shell_output("#{bin}/atlas schema inspect -u \"mysql://user:pass@localhost:3306/dbname\" 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/atlas version")
  end
end
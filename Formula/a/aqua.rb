class Aqua < Formula
  desc "Declarative CLI Version manager"
  homepage "https://aquaproj.github.io/"
  url "https://ghfast.top/https://github.com/aquaproj/aqua/archive/refs/tags/v2.53.5.tar.gz"
  sha256 "8ff0370a85b1bb6e45f444d76ad1abc0063520f32e537762c6e6f7970db4f660"
  license "MIT"
  head "https://github.com/aquaproj/aqua.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ae59032e2e29ec8da6e57ae1b83503a30aa9735789cde9bc093557f38b7526ad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ae59032e2e29ec8da6e57ae1b83503a30aa9735789cde9bc093557f38b7526ad"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ae59032e2e29ec8da6e57ae1b83503a30aa9735789cde9bc093557f38b7526ad"
    sha256 cellar: :any_skip_relocation, sonoma:        "8418c4ff80660654983e1321104b46bb3d3ed7dcf2e0746687ebae907dc35c68"
    sha256 cellar: :any_skip_relocation, ventura:       "8418c4ff80660654983e1321104b46bb3d3ed7dcf2e0746687ebae907dc35c68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de82747d26034e72729cdac0f4666caa65b2f90add405afb95b2193a2ca5d619"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/aqua"

    generate_completions_from_executable(bin/"aqua", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/aqua --version")

    system bin/"aqua", "init"
    assert_match "depName=aquaproj/aqua-registry", (testpath/"aqua.yaml").read
  end
end
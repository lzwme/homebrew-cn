class Massdriver < Formula
  desc "Manage applications and infrastructure on Massdriver Cloud"
  homepage "https://www.massdriver.cloud/"
  url "https://ghfast.top/https://github.com/massdriver-cloud/mass/archive/refs/tags/1.14.1.tar.gz"
  sha256 "9bd9ab0481e26d4ee60ce3e1dc007855fe739add3eef2b2bf48f6e37dca30fe5"
  license "Apache-2.0"
  head "https://github.com/massdriver-cloud/mass.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d170e047d22f54f16b1ff912896fde9b126130bfc93a1a37a3725ecaa977dfaa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d170e047d22f54f16b1ff912896fde9b126130bfc93a1a37a3725ecaa977dfaa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d170e047d22f54f16b1ff912896fde9b126130bfc93a1a37a3725ecaa977dfaa"
    sha256 cellar: :any_skip_relocation, sonoma:        "e603d62d5a772dc2c66349ee2256fe16c9de9331fd02937afeebb505167a2041"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "01f0ee6fd48cb8febb544f70f8636b400cd5e887cc72a0e2989d05bfa8866bf7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "91a91f6216ba1507451cf481f3a10e293e4de2445420d60a43acb670206a9d06"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/massdriver-cloud/mass/pkg/version.version=#{version}
      -X github.com/massdriver-cloud/mass/pkg/version.gitSHA=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"mass")

    generate_completions_from_executable(bin/"mass", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mass version")

    output = shell_output("#{bin}/mass bundle build 2>&1", 1)
    assert_match "Error: open massdriver.yaml: no such file or directory", output
  end
end
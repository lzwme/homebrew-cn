class Jjui < Formula
  desc "TUI for interacting with the Jujutsu version control system"
  homepage "https://github.com/idursun/jjui"
  url "https://ghfast.top/https://github.com/idursun/jjui/archive/refs/tags/v0.9.2.tar.gz"
  sha256 "40ec31984faf65dad60bc1c5f40f91173e31b954f7321aafb523e3724dc8772f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "52094f0d73847a78bc80a1c061f2ad2c57c5bdaf4dff3348382f951e5654a459"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "52094f0d73847a78bc80a1c061f2ad2c57c5bdaf4dff3348382f951e5654a459"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "52094f0d73847a78bc80a1c061f2ad2c57c5bdaf4dff3348382f951e5654a459"
    sha256 cellar: :any_skip_relocation, sonoma:        "4e1ebf367cb2d98d30955eaf2e88815a39ccb637268124202db61af55b7f967e"
    sha256 cellar: :any_skip_relocation, ventura:       "4e1ebf367cb2d98d30955eaf2e88815a39ccb637268124202db61af55b7f967e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "187f4a00415f157e3925390493ef3d4ed42372b8dc899d198061ba904e4ca4fa"
  end

  depends_on "go" => :build
  depends_on "jj"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}"), "./cmd/jjui"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jjui -version")
    assert_match "Error: There is no jj repo in", shell_output("#{bin}/jjui 2>&1", 1)
  end
end
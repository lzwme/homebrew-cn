class Lazydocker < Formula
  desc "Lazier way to manage everything docker"
  homepage "https://github.com/jesseduffield/lazydocker"
  url "https://github.com/jesseduffield/lazydocker.git",
      tag:      "v0.21.0",
      revision: "e8e808ff47a75220b52dcfad68055e7f028023cc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c0e7f93d3e3e2d0d90380b63f15b0773d19dc995c301018535a1dbe54ea4721b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c0e7f93d3e3e2d0d90380b63f15b0773d19dc995c301018535a1dbe54ea4721b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c0e7f93d3e3e2d0d90380b63f15b0773d19dc995c301018535a1dbe54ea4721b"
    sha256 cellar: :any_skip_relocation, ventura:        "a70037fd1e0b3fad01968ebb05979035af0f0bf084aeef2379dd63582ddf9f59"
    sha256 cellar: :any_skip_relocation, monterey:       "a70037fd1e0b3fad01968ebb05979035af0f0bf084aeef2379dd63582ddf9f59"
    sha256 cellar: :any_skip_relocation, big_sur:        "a70037fd1e0b3fad01968ebb05979035af0f0bf084aeef2379dd63582ddf9f59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8ba00c3fce50e21b6345c5c776744b746a4fb2b6458956b441308dd793bb2088"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X main.version=#{version} -X main.buildSource=homebrew"
    system "go", "build", "-mod=vendor", *std_go_args(ldflags: ldflags)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lazydocker --version")

    assert_match "language: auto", shell_output("#{bin}/lazydocker --config")
  end
end
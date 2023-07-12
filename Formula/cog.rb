class Cog < Formula
  desc "Containers for machine learning"
  homepage "https://github.com/replicate/cog"
  url "https://ghproxy.com/https://github.com/replicate/cog/archive/refs/tags/v0.8.1.tar.gz"
  sha256 "c898892c2b7e796e742eb981b1fe83c5f63bb7a420ace3e2d67aa289c0880aa8"
  license "Apache-2.0"
  head "https://github.com/replicate/cog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "019c4f78d93a90ab18e509e6dadee6dc2892cd6145bc667bb46c85dd270a9cc6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b005861cf48af80075016731994b8d6441b722b0cddf7314966d8d5b5fbc0234"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0009df9d46aa6af2ed4965efbb9201fa27c46111a45ff30f6bca4e04d70d3459"
    sha256 cellar: :any_skip_relocation, ventura:        "10a24c3cf4e3c54d4e80826e0b13b658e13c9188883bb39647ecfee1df8da995"
    sha256 cellar: :any_skip_relocation, monterey:       "234d7295597ba6e58fa7970818bd694e2ec1cfbcbbaedaf17e555b3d6f48df23"
    sha256 cellar: :any_skip_relocation, big_sur:        "9403e03a4472cb2a523c7941e64dd98f264066dbee9048eb62bbbc169d8ca721"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "256a22e944365b9519e2961a01dc4a18d49464441a6ecaf60b51e93a570612e9"
  end

  depends_on "go" => :build

  uses_from_macos "python" => :build

  def install
    ENV["SETUPTOOLS_SCM_PRETEND_VERSION"] = version.to_s
    system "make", "COG_VERSION=#{version}", "PYTHON=python3"
    bin.install "cog"
    generate_completions_from_executable(bin/"cog", "completion")
  end

  test do
    assert_match "cog version #{version}", shell_output("#{bin}/cog --version")
    assert_match "cog.yaml not found", shell_output("#{bin}/cog build 2>&1", 1)
  end
end
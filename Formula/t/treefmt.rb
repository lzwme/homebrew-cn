class Treefmt < Formula
  desc "One CLI to format the code tree"
  homepage "https:treefmt.comlatest"
  url "https:github.comnumtidetreefmtarchiverefstagsv2.3.0.tar.gz"
  sha256 "841b981c69751b2906134d3a63e0b73433a40da99bfd9cbaf1a0c38ad161e87e"
  license "MIT"
  head "https:github.comnumtidetreefmt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fdee84110d11c4f97a21070b1cb58fcd590602750c7407d0b7bafbd3354d9133"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fdee84110d11c4f97a21070b1cb58fcd590602750c7407d0b7bafbd3354d9133"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fdee84110d11c4f97a21070b1cb58fcd590602750c7407d0b7bafbd3354d9133"
    sha256 cellar: :any_skip_relocation, sonoma:        "a50e7012dde0038a99f736a37d3fb630af8ad3dd9144847e169ffda761921d98"
    sha256 cellar: :any_skip_relocation, ventura:       "a50e7012dde0038a99f736a37d3fb630af8ad3dd9144847e169ffda761921d98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4149e3244d3b7f865eff027723a42efd93d609645e06839cd0d3dff4860103f7"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.comnumtidetreefmtv2build.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    output = shell_output("#{bin}treefmt 2>&1", 1)
    assert_match "failed to find treefmt config file: could not find [treefmt.toml .treefmt.toml]", output
    assert_match version.to_s, shell_output("#{bin}treefmt --version")
  end
end
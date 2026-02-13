class Render < Formula
  desc "Command-line interface for Render"
  homepage "https://render.com/docs/cli"
  url "https://ghfast.top/https://github.com/render-oss/cli/archive/refs/tags/v2.9.1.tar.gz"
  sha256 "37a282188571ca83a188e7b0ae62e20fe5a79eb09119a95bd85fedf34cd06576"
  license "Apache-2.0"
  head "https://github.com/render-oss/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "97bfddedebd606f0c3f813108dd4cfe0dab92d163841c2e66974c1e5de659a12"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "97bfddedebd606f0c3f813108dd4cfe0dab92d163841c2e66974c1e5de659a12"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "97bfddedebd606f0c3f813108dd4cfe0dab92d163841c2e66974c1e5de659a12"
    sha256 cellar: :any_skip_relocation, sonoma:        "53cad523cb8f7650302be7637e40c3a9a087ec8026d197d0ed94d8d37ae42076"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "62bec0d8725df6d7ce611315ebd7783e6b8baf06249c0246a620f3e7a796c485"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f7feb33711563c11e0f52fbb7194db01a38dcbaa815033510c12fcb732f4ad66"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/render-oss/cli/pkg/cfg.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/render --version")

    output = shell_output("#{bin}/render services -o json 2>&1", 1)
    assert_match "Error: no workspace set. Use `render workspace set` to set a workspace", output
  end
end
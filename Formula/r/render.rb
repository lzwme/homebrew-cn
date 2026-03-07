class Render < Formula
  desc "Command-line interface for Render"
  homepage "https://render.com/docs/cli"
  url "https://ghfast.top/https://github.com/render-oss/cli/archive/refs/tags/v2.12.0.tar.gz"
  sha256 "4fd3b36c924d637859b421bb8af932ae08830e08ef46e8a5c52ccdd573a764f0"
  license "Apache-2.0"
  head "https://github.com/render-oss/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f1c3fa9a297c32c41f674de990449615c3e8c96ee29f48a9f9b844fcf780cfba"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f1c3fa9a297c32c41f674de990449615c3e8c96ee29f48a9f9b844fcf780cfba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f1c3fa9a297c32c41f674de990449615c3e8c96ee29f48a9f9b844fcf780cfba"
    sha256 cellar: :any_skip_relocation, sonoma:        "5b488c8cbf35798e029860711491f6ed5fe1ec01a1d5a100b4f29e10963b0b84"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f8ec6a1873b37caeeecd2c8b9279d1a6f02576036db827778501717c180f02f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0233cf3c92701e2b68aaa62f781931ad805d0678bd36dcb1143ddb3ebf954788"
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
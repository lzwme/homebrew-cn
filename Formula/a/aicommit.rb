class Aicommit < Formula
  desc "AI-powered commit message generator"
  homepage "https:github.comcoderaicommit"
  url "https:github.comcoderaicommitarchiverefstagsv0.6.5.tar.gz"
  sha256 "b89c00eabd881344a0e1ee3fe2d5bbf5005cfd19881f5d3a4b23bc8dd0a98a0b"
  license "CC0-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7a7c316f47dae0539e95407a1d404c7ccbb37f771f6a9049e3abc6dc6421484c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7a7c316f47dae0539e95407a1d404c7ccbb37f771f6a9049e3abc6dc6421484c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7a7c316f47dae0539e95407a1d404c7ccbb37f771f6a9049e3abc6dc6421484c"
    sha256 cellar: :any_skip_relocation, sonoma:        "03e62c692d3d64bc97dd6a388a8e3b810c1c8d8830a76495e0c8a80a689655a4"
    sha256 cellar: :any_skip_relocation, ventura:       "03e62c692d3d64bc97dd6a388a8e3b810c1c8d8830a76495e0c8a80a689655a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "848a5368d7881eb41335e58e54eb995252a4339ef65802360df8abcd05928b6b"
  end

  depends_on "go"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=v#{version}"), ".cmdaicommit"
  end

  test do
    assert_match "aicommit v#{version}", shell_output("#{bin}aicommit version")

    system "git", "init", "--bare", "."
    assert_match "err: $OPENAI_API_KEY is not set", shell_output("#{bin}aicommit 2>&1", 1)
  end
end
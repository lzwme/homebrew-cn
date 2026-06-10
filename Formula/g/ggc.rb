class Ggc < Formula
  desc "Modern Git CLI"
  homepage "https://github.com/bmf-san/ggc"
  url "https://ghfast.top/https://github.com/bmf-san/ggc/archive/refs/tags/v8.6.7.tar.gz"
  sha256 "2d7be9d13035ec8ab059e7bde4a042f541dcdbce28aeb6843cf2aa7479e1c1d3"
  license "MIT"
  head "https://github.com/bmf-san/ggc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6a2620504a95c23c077c06bbbde3a82a2a355e7c6f55cca1c852b3f60fd0f8e9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6a2620504a95c23c077c06bbbde3a82a2a355e7c6f55cca1c852b3f60fd0f8e9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6a2620504a95c23c077c06bbbde3a82a2a355e7c6f55cca1c852b3f60fd0f8e9"
    sha256 cellar: :any_skip_relocation, sonoma:        "f627b37e7a5ad4168d20a2eddc21e5bce2825a7bfa7b7c947fa680257fd97ecd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9a20a9bed714336a157700c9fa8df1dbcca1a176f78cdec0b0bc4cad662801a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b985643b1d6a4f7522910163acf722509b4073d4e41fea6c687dc75346036b7f"
  end

  depends_on "go" => :build

  uses_from_macos "vim"

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ggc version")
    assert_equal "main", shell_output("#{bin}/ggc config get default.branch").chomp
  end
end
class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://ghfast.top/https://github.com/runkids/skillshare/archive/refs/tags/v0.19.21.tar.gz"
  sha256 "285635be136be531e0ab596aaed934f39391114e95f512688b227e6e5c403281"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "20fd66046d431a76d4ece5d6533edd6ae1331a615d0e2ba98a8303649ccb047e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "20fd66046d431a76d4ece5d6533edd6ae1331a615d0e2ba98a8303649ccb047e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "20fd66046d431a76d4ece5d6533edd6ae1331a615d0e2ba98a8303649ccb047e"
    sha256 cellar: :any_skip_relocation, sonoma:        "aea9edcc9ad246f9ae24a1b071676f05a8cdc6076fd2f6e1e9f67ee1f4544de6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8b3f83bbe3037e33d5e126899c225ab963681361a3d854c17e8e0c85d6a1df59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b0185b7845fb412790a131a26ff66175e91d5fe06d7e0dc1c917a0a2643c2062"
  end

  depends_on "go" => :build

  def install
    # Avoid building web UI
    ui_path = "internal/server/dist"
    mkdir_p ui_path
    (buildpath/"#{ui_path}/index.html").write "<!DOCTYPE html><html><body><h1>UI not built</h1></body></html>"

    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/skillshare"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/skillshare version")

    assert_match "config not found", shell_output("#{bin}/skillshare sync 2>&1", 1)
  end
end
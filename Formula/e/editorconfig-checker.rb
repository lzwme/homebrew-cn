class EditorconfigChecker < Formula
  desc "Tool to verify that your files are in harmony with your .editorconfig"
  homepage "https://editorconfig-checker.github.io/"
  url "https://ghfast.top/https://github.com/editorconfig-checker/editorconfig-checker/archive/refs/tags/v4.0.0.tar.gz"
  sha256 "b350ded643f122036c685c770914c54d09e7c6beccfb564b2bdcbdcc7fc90014"
  license "MIT"
  head "https://github.com/editorconfig-checker/editorconfig-checker.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "003e7ddd098b4d18085561551a219553da8a685b301f4fb8e910af6728768dc5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "003e7ddd098b4d18085561551a219553da8a685b301f4fb8e910af6728768dc5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "003e7ddd098b4d18085561551a219553da8a685b301f4fb8e910af6728768dc5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a6e189d97b36ddc1c432063671e6b4049eddc1c409172875f7e741edea0b4415"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9bb348d57f39b1b39d73b4d3793b5b4580979de11eda009abe5083b477059481"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/editorconfig-checker/main.go"
  end

  test do
    (testpath/".editorconfig").write <<~EOS
      [version.txt]
      charset = utf-8
    EOS
    (testpath/"version.txt").write <<~EOS
      version=#{version}
    EOS

    system bin/"editorconfig-checker", testpath/"version.txt"

    assert_match version.to_s, shell_output("#{bin}/editorconfig-checker --version")
  end
end
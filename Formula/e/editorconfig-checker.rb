class EditorconfigChecker < Formula
  desc "Tool to verify that your files are in harmony with your .editorconfig"
  homepage "https://editorconfig-checker.github.io/"
  url "https://ghfast.top/https://github.com/editorconfig-checker/editorconfig-checker/archive/refs/tags/v3.11.2.tar.gz"
  sha256 "8f067347f75a0d61b3e8ba08e2d7ecefca2255cae7d95e5386a3931d066945c3"
  license "MIT"
  head "https://github.com/editorconfig-checker/editorconfig-checker.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "da9279e347abf628c2d93b3a21fdb719974cff20449c2dfe14654dfb5efa07d2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "da9279e347abf628c2d93b3a21fdb719974cff20449c2dfe14654dfb5efa07d2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "da9279e347abf628c2d93b3a21fdb719974cff20449c2dfe14654dfb5efa07d2"
    sha256 cellar: :any_skip_relocation, sonoma:        "e727184bedaa71a7f77c43470bd853db1eb1c11b4bb28a96a2a7bf315c721b9e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "abc940e2b83ddc05da3b7959cdca3b37500ab2ebefb48d59943ded6e14f683df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fbddeb29c6af47b941b48ef38e3e120d1199f0d9ffe4b2a24bae3a0828029830"
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
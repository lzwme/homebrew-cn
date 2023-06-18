class Tbls < Formula
  desc "CI-Friendly tool for document a database"
  homepage "https://github.com/k1LoW/tbls"
  url "https://ghproxy.com/https://github.com/k1LoW/tbls/archive/refs/tags/v1.67.0.tar.gz"
  sha256 "171a0f36bf0991c4f9d4ecc29e2dcc109020519f99925702adfa6752fd816f3e"
  license "MIT"
  head "https://github.com/k1LoW/tbls.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b89116e78813bc5f661a4384b1020eec2056351097eeda1ce4dcfcc59fbb64ae"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "531988dd8e606ee8320a7036bb24a468b122fa742c3ed3bd0a778de926c1cf18"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3ef8deac1b64396a6f1357fd3cbc53c9a96c0021d06d945e8489a0a3d0aca62b"
    sha256 cellar: :any_skip_relocation, ventura:        "d9026f5fa46f11e87850a12f2ae2df8d11786e1cac3be7c4cf2d70eece73a88d"
    sha256 cellar: :any_skip_relocation, monterey:       "c46d53b78a5fb1a3af088c7dbb3f29de00e8a8c1e90a56c75ebcee5169b88330"
    sha256 cellar: :any_skip_relocation, big_sur:        "795e4cf562b8f0bcbd33bec131ae1f276cc69eba280b9bc272851a7e3539decc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2bfa215ea48fbe5f3d638705d2db0248ce69fd114081815db2a3775a186db000"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/k1LoW/tbls.version=#{version}
      -X github.com/k1LoW/tbls.date=#{time.iso8601}
      -X github.com/k1LoW/tbls/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"tbls", "completion")
  end

  test do
    assert_match "invalid database scheme", shell_output(bin/"tbls doc", 1)
    assert_match version.to_s, shell_output(bin/"tbls version")
  end
end
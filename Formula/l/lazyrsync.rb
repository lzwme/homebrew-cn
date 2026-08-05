class Lazyrsync < Formula
  desc "Terminal UI for rsync, written in Rust"
  homepage "https://lazyrsync.westpoint.io/"
  url "https://ghfast.top/https://github.com/westpoint-io/lazyrsync/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "4ce106e10a258ccb4fdf8958b49746f7a1f9386592ede441f620a7f41ffb7d75"
  license "MIT"
  head "https://github.com/westpoint-io/lazyrsync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d5282bbd2eb8b8548710ba9ae39120cb30f9dbaf88ffe3c8ad1eea5993d2b101"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0f7186414294c0580faf1c2f3b333f9630cd79cd60da885bb4e527b4c4382b51"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "249457976531d1d391352acb729dedb7ea80e06d87d483b037af051becf60821"
    sha256 cellar: :any_skip_relocation, sonoma:        "53c31e28cd88ce127f6e806351edfdeeddf9634da5fef86b2532ec69b0b70ec1"
    sha256 cellar: :any,                 arm64_linux:   "eb344ad831420d14fc2c8543a84888e86fcb306d350e274fc2bca8382000e065"
    sha256 cellar: :any,                 x86_64_linux:  "5bca5e4824334e373b52bd8aa831d315ae3593d28a37354caa39facd85358947"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lazyrsync --version")

    assert_match "No profiles", shell_output("#{bin}/lazyrsync list")
  end
end
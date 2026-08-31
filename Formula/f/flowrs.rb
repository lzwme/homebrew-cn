class Flowrs < Formula
  desc "TUI application for Apache Airflow"
  homepage "https://github.com/jvanbuel/flowrs"
  url "https://ghfast.top/https://github.com/jvanbuel/flowrs/archive/refs/tags/flowrs-tui-v0.14.1.tar.gz"
  sha256 "c8d4cd2a6118a2b809b99900782bea8e8305e1c47103bd1cddcef5c11bf66367"
  license "MIT"
  head "https://github.com/jvanbuel/flowrs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^flowrs-tui-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8309ffd9d0a1469a7bdf1fbe777901c3d643b2935ac58c6ed8196bf034721412"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f557f973aca48a792b80f68ac6041031326d31a35a4806cd2facf7c8262605c5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5db433bee62d36d22a0282da5689bbb9a88478ae1bf2d455e41c27216c083c70"
    sha256 cellar: :any,                 arm64_linux:   "daaac2f72f2ed8cc440d1af8daffe5dff45272bb555aedaabdae0c5a0e77a4d9"
    sha256 cellar: :any,                 x86_64_linux:  "89239226e7f675fdf25d170da3e374ef2a6a31e668e717598f7f083e2a2747f3"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/flowrs --version")
    assert_match "No servers found in the config file", shell_output("#{bin}/flowrs config list")
  end
end
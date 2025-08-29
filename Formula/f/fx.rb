class Fx < Formula
  desc "Terminal JSON viewer"
  homepage "https://fx.wtf"
  url "https://ghfast.top/https://github.com/antonmedv/fx/archive/refs/tags/39.0.3.tar.gz"
  sha256 "779be27beea878110664299fca5e2b60bc712854be45868726e9ef4a7ab4874b"
  license "MIT"
  head "https://github.com/antonmedv/fx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "82544e1b45a1aec03439cd1a476395368ecfbae52e6e8b3e68b01e6af03754c2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "82544e1b45a1aec03439cd1a476395368ecfbae52e6e8b3e68b01e6af03754c2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "82544e1b45a1aec03439cd1a476395368ecfbae52e6e8b3e68b01e6af03754c2"
    sha256 cellar: :any_skip_relocation, sonoma:        "ad9cad59b2a0f56b3ef5d868db72034415b6c5d0dbd5393a19edf211f2c9f41b"
    sha256 cellar: :any_skip_relocation, ventura:       "ad9cad59b2a0f56b3ef5d868db72034415b6c5d0dbd5393a19edf211f2c9f41b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b9c243ad31cf28fa8658bda72c292cfe21a35587746e4246ad0f77a97cad41fa"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    generate_completions_from_executable(bin/"fx", "--comp")
  end

  test do
    assert_equal "42", pipe_output("#{bin}/fx .", "42").strip
  end
end
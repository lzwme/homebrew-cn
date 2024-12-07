class Oxlint < Formula
  desc "Suite of high-performance tools for JavaScript and TypeScript written in Rust"
  homepage "https:oxc.rs"
  url "https:github.comoxc-projectoxcarchiverefstagsoxlint_v0.14.1.tar.gz"
  sha256 "0849d7c4530ba57959506b95874e83e44806b4f4f4d57f8e9bae277be229a478"
  license "MIT"
  head "https:github.comoxc-projectoxc.git", branch: "main"

  livecheck do
    url :stable
    regex(^oxlint[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5a38cd86ea21f724ea31f59a4c5cf305c8e688aa833ab9767901decef7826df6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "30dc0cde6de5418e9ea763543d80d787bda29fd82e3743b146a3aa843f80dad3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "02a96bd6842cac704dbafb90f15c87a9adc13c663c09afd09ee7a65f2a266b87"
    sha256 cellar: :any_skip_relocation, sonoma:        "e010a4e15b47af6728535eecb16f7d5c94a898012984717d6a3d1426d69b9874"
    sha256 cellar: :any_skip_relocation, ventura:       "09a21536a19781ecd7abc8e973fc344d7d498d5c19f73ed4298406836baf289e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4970bf8483b9ab686aa8c9562dd58882cfecf84e54ec318c6549e780cc6ae7da"
  end

  depends_on "rust" => :build

  def install
    ENV["OXC_VERSION"] = version.to_s
    system "cargo", "install", *std_cargo_args(path: "appsoxlint")
  end

  test do
    (testpath"test.js").write "const x = 1;"
    output = shell_output("#{bin}oxlint test.js 2>&1")
    assert_match "eslint(no-unused-vars): Variable 'x' is declared but never used", output

    assert_match version.to_s, shell_output("#{bin}oxlint --version")
  end
end
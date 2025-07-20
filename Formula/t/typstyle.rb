class Typstyle < Formula
  desc "Beautiful and reliable typst code formatter"
  homepage "https://typstyle-rs.github.io/typstyle/"
  url "https://ghfast.top/https://github.com/typstyle-rs/typstyle/archive/refs/tags/v0.13.16.tar.gz"
  sha256 "fe39613f91b373170ca359524bf69f66722c536c3e2bee0965db9fe5983ee563"
  license "Apache-2.0"
  head "https://github.com/typstyle-rs/typstyle.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1dbbe30208f36b0942508b52eff996efafe7c6c5ad026fa7c6ecf7eb01e84206"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cb2983d580566ab32f99c4b530bbce5722451a0ddb0724f97dcfc04856232d9c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9515603e39ebbbf1bcd1b22a268fbcbe2622efee53b335c9d56d91db53478962"
    sha256 cellar: :any_skip_relocation, sonoma:        "40a177285080c1e73707a162e8895671bb23f6e8c6d91226158a1124296784b1"
    sha256 cellar: :any_skip_relocation, ventura:       "4ea787e45daacf9b998a3fd651cbc3cbca2f97a9295366122e01fd152303e336"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5f9bc091bde68aa77beefb0f3f09fa5d0048dab9a59b0ce8430a02ae30ff9bcc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7c4d74113ccdbeb9a223bbe2d6ff317620c153a2b4c979a2d1502e04bcbd0eaf"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/typstyle")

    generate_completions_from_executable(bin/"typstyle", "completions")
  end

  test do
    (testpath/"Hello.typ").write("Hello World!")
    system bin/"typstyle", "Hello.typ"

    assert_match version.to_s, shell_output("#{bin}/typstyle --version")
  end
end
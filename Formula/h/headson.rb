class Headson < Formula
  desc "Head/tail for structured data"
  homepage "https://docs.rs/headson/latest/headson/"
  url "https://ghfast.top/https://github.com/kantord/headson/archive/refs/tags/headson-v0.16.1.tar.gz"
  sha256 "485c221b28b361c9de2b8223f7985401d37f2c75a2870be6f59af4d83f499db7"
  license "MIT"
  head "https://github.com/kantord/headson.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b770e733158b889b0fa333648be02473bb8804aa9d40602a42a08e01c7c166ba"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e84fa119d1355c81443eb195e4dc28cadc437a11961cbeb9b582a65a2b140dc7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fe26f021effb8b842b4733dd995a385b310ed87b353f68a84e954ab0f0686431"
    sha256 cellar: :any_skip_relocation, sonoma:        "2ba8276f8f4197d07cd42acaccdb3c4e0aad66b18cf2adab4d8d3047a77be9c2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ba82ca7ea766ebccfb645e31f4a86ccce244d060867c90ee26f6a710bb15585c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2161ea635c9ef6a70ecb96711a348e225968d2933a3c84d6349af0d8d788e37f"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"hson", "--completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hson --version")

    (testpath/"test.json").write '{"a":1,"b":[2,3]}'
    assert_match '"a":1', shell_output("#{bin}/hson --compact #{testpath}/test.json")
  end
end
class Headson < Formula
  desc "Head/tail for structured data"
  homepage "https://docs.rs/headson/latest/headson/"
  url "https://ghfast.top/https://github.com/kantord/headson/archive/refs/tags/headson-v0.13.0.tar.gz"
  sha256 "b135fdeeb9808a4f36851569c7e6f982c728e460767c1c60a72a498d254d4e0a"
  license "MIT"
  head "https://github.com/kantord/headson.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "184287ab7881ff0692b672749daa111c620c00df5ffdb0a229b15d9a26eec2cd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cea00a30795a3863dfd0d081f8fc6cef9534fb2794025236c37c51191a487d75"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5e29f2f786e0016d5c9e6331285479e0af6682b6437ca6f3d2bcaf675266cf24"
    sha256 cellar: :any_skip_relocation, sonoma:        "d4adeda4f452fe48d4aaed3c11dc7971f30ffd90d12cd505a677ac1d919dd111"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "59e20ee42eef6939499c83501c6e410f6c2096eae76b5fac6013d408a47d091e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d459753c0e6a219def36425a06c50e2d604c4f4c585cfb0e9fba270dd96cad84"
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
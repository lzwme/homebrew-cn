class Yamlfmt < Formula
  desc "Extensible command-line tool to format YAML files"
  homepage "https://github.com/google/yamlfmt"
  url "https://ghfast.top/https://github.com/google/yamlfmt/archive/refs/tags/v0.18.1.tar.gz"
  sha256 "aec8d5cb8ca395ed60bddeb14d4a4076d5b46939a3a9cd6773eb1913d2d63a0e"
  license "Apache-2.0"
  head "https://github.com/google/yamlfmt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3b2ced127a405d1f950d18f54dc4da8bf2d40fa8b67483d3c451460660a90770"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3b2ced127a405d1f950d18f54dc4da8bf2d40fa8b67483d3c451460660a90770"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3b2ced127a405d1f950d18f54dc4da8bf2d40fa8b67483d3c451460660a90770"
    sha256 cellar: :any_skip_relocation, sonoma:        "1c1483a890a851178a2c1e8902c81063a66dfafc68e02b0a0be9e0d600958228"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "388231a58bac3b788b0b8367c657be959671f0d39ab68046323d04059a114c07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de478248b430d297c3178106c6518cab44691a0340af35cc5bb177df48986de9"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/yamlfmt"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/yamlfmt -version")

    (testpath/"test.yml").write <<~YAML
      foo: bar
    YAML
    system bin/"yamlfmt", "-lint", "test.yml"
  end
end
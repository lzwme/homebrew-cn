class Yamlfmt < Formula
  desc "Extensible command-line tool to format YAML files"
  homepage "https://github.com/google/yamlfmt"
  url "https://ghfast.top/https://github.com/google/yamlfmt/archive/refs/tags/v0.19.0.tar.gz"
  sha256 "257dd1521895c6b22ab4c71c27fa27f2290d05cedd0734f819573b509039e9b2"
  license "Apache-2.0"
  head "https://github.com/google/yamlfmt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5c59ed48d2534326566255ca209edd314aa0182db4132fe43c5ab4dc3fcebc20"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5c59ed48d2534326566255ca209edd314aa0182db4132fe43c5ab4dc3fcebc20"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5c59ed48d2534326566255ca209edd314aa0182db4132fe43c5ab4dc3fcebc20"
    sha256 cellar: :any_skip_relocation, sonoma:        "423f2da3e7064f7eb996843d90b6692c692c0535af0429c88f74c774e379c17d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "26beaa3991b22b29d8ef67adf7af3b107c89b4ab7ed3171fcaee2df52d4b7323"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "92f38abcf0be10615688c6547d59c2443207d62454a0ee575d36ffec5b7e599a"
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
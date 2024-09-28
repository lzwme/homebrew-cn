class Roxctl < Formula
  desc "CLI for Stackrox"
  homepage "https:www.stackrox.io"
  url "https:github.comstackroxstackroxarchiverefstags4.5.2.tar.gz"
  sha256 "8ee9b981b890dea660dbacffc01350ef85ad4bfe2e17bf650f8022b272a0c090"
  license "Apache-2.0"
  head "https:github.comstackroxstackrox.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2cf091d17e883d9b0d93518019837645a156f7de419f478e2e24e8122b745952"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fe2e8cd8a1d21435df608137df9fcd841cb84cd25c054f99171b533c0a7ffef1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2ef73513f1773c8fa6d6cf8ce0dc130baf245925e54363ebee0dc81ca42c0aae"
    sha256 cellar: :any_skip_relocation, sonoma:        "86b9dbf290ee583a3d4ffd0cd11124fc36ef12af48b27c64c87c5ed7d29e6653"
    sha256 cellar: :any_skip_relocation, ventura:       "f15199fc939c390bfa6caef924b8d8d64fc23c404f96d09654200d418015b3e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab3775ffd2f4e506521fb2c52088c0246dfcc4135a47a3dffc3e4d86a59f9522"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), ".roxctl"

    generate_completions_from_executable(bin"roxctl", "completion")
  end

  test do
    output = shell_output("#{bin}roxctl central whoami 2<&1", 1)
    assert_match <<~EOS, output
      ERROR:	obtaining auth information for localhost:8443: \
      retrieving token: no credentials found for localhost:8443, please run \
      "roxctl central login" to obtain credentials
    EOS
  end
end
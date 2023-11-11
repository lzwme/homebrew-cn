class Runme < Formula
  desc "Execute commands inside your runbooks, docs, and READMEs"
  homepage "https://runme.dev/"
  url "https://ghproxy.com/https://github.com/stateful/runme/archive/refs/tags/v1.8.2.tar.gz"
  sha256 "d8b172db84bdc309b5ec1f8088f992cb6927df986b51b2423640bfbebf0a3a5a"
  license "Apache-2.0"
  head "https://github.com/stateful/runme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8693a0d513d0093feb37a0058772db0b6f9f0efb4d3855c8cb5e934a9236bd13"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dc0119425522f564b58aa586d8da16c969691128ac0ef4392b0e65ba14b9fd9d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7d0a2b373ada85b45d330525ec2a6443ddb16740234f94a4f2d24ce3bdacfb7d"
    sha256 cellar: :any_skip_relocation, sonoma:         "cde2e47e763a7158093b19b1bbed328f663d6515c70b904a046db0685d0742ad"
    sha256 cellar: :any_skip_relocation, ventura:        "bc77ae704e56caecd1a06568f9f37190bdd529cba8cedb2a26e9c64acd3f5318"
    sha256 cellar: :any_skip_relocation, monterey:       "d05967c28745c0f653164ac5c86da50c038e749394e5e0d18823a12ddbacde14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7f6b905ff306373f60d2d818ae29993af0efc493b19d7daa1aba6460b47c256f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/stateful/runme/internal/version.BuildDate=#{time.iso8601}
      -X github.com/stateful/runme/internal/version.BuildVersion=#{version}
      -X github.com/stateful/runme/internal/version.Commit=#{tap.user}
    ]

    system "go", "build", "-o", bin, *std_go_args(ldflags: ldflags)
    generate_completions_from_executable(bin/"runme", "completion")
  end

  test do
    system "#{bin}/runme", "--version"
    markdown = (testpath/"README.md")
    markdown.write <<~EOS
      # Some Markdown

      Has some text.

      ```sh { name=foobar }
      echo "Hello World"
      ```
    EOS
    assert_match "Hello World", shell_output("#{bin}/runme run foobar")
    assert_match "foobar", shell_output("#{bin}/runme list")
  end
end
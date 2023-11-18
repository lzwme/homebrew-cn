class Mods < Formula
  desc "AI on the command-line"
  homepage "https://github.com/charmbracelet/mods"
  url "https://ghproxy.com/https://github.com/charmbracelet/mods/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "a615e7db5aa6e0cd353a488219bb35ea8f9732fc107daee6d3b89d7f16cef54d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "020a09cc252ea44db99e0fdc4202258bf90e66fea5f76ec41d1356a3721017aa"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8c5e9d92362920f0d9da25a0a33894f904e8f27ac9938638a1832776d263e61f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7528018ee38c126b3e51effde3f1f4a2231162a2022a0a7b0105ba992fd25215"
    sha256 cellar: :any_skip_relocation, sonoma:         "d6f2332e2efdb11e88cc6f0dd54c7c5c495a37628aed56f06d7839dee1c1e56d"
    sha256 cellar: :any_skip_relocation, ventura:        "1a03d2931f36cf6101da24ee694de260f63aeeb0d6b003a1fe916dc4c67795c0"
    sha256 cellar: :any_skip_relocation, monterey:       "1cd1d1176d06510e4f1cc37182867e4af9423ecacc941bc9093b91f34f1394bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e140d90095afbbcde1a1bd58b02cf79441dcf3de4dc745af3814924f18c3ed20"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.Version=#{version}
      -X main.CommitSHA=#{tap.user}
      -X main.CommitDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    ENV["OPENAI_API_KEY"] = "faketest"

    output = pipe_output(bin/"mods 2>&1", "Hello, Homebrew!", 1)
    assert_match "Invalid OpenAI API key", output

    assert_match version.to_s, shell_output(bin/"mods --version")
  end
end
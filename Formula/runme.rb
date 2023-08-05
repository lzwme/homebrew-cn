class Runme < Formula
  desc "Execute commands inside your runbooks, docs, and READMEs"
  homepage "https://runme.dev/"
  url "https://github.com/stateful/runme.git",
      tag:      "v1.7.1",
      revision: "3103a79ac158f97e0f054b56dba45375e32eca20"
  license "Apache-2.0"
  head "https://github.com/stateful/runme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f74259dac24f58c4ee2ebf4ff9fdbef599b574c7fb052c23581caac4714eab15"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0edc33f15cc035145c14029856b7c8dfc439854b5a9a69ade81ca1f362b1316c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7362a29808b4d704ac87b51493c1084b1e46253028db092fb9765b05d02ea73e"
    sha256 cellar: :any_skip_relocation, ventura:        "f378e8f0eb9065e9b31e09c01222ff67c12f03d49ed5fee22da882dcf01e4837"
    sha256 cellar: :any_skip_relocation, monterey:       "9ff2ae66156eaff6e68cfdebad4debfcfc4fe479d9ba43340158aeadae010ef5"
    sha256 cellar: :any_skip_relocation, big_sur:        "21eb0570530b58d17877c0f1c628bd280b60f407a7c63804568b072b39e4dd6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "493b0e39e7d8c9d75e7dca1de0c718c33d1b35d099334d1b0906217764091f54"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/stateful/runme/internal/version.BuildDate=#{time.iso8601}
      -X github.com/stateful/runme/internal/version.BuildVersion=#{version}
      -X github.com/stateful/runme/internal/version.Commit=#{Utils.git_head}
    ]

    system "go", "build", "-o", bin, *std_go_args(ldflags: ldflags), "./main.go"
    generate_completions_from_executable(bin/"runme", "completion", shells: [:bash, :zsh, :fish])
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
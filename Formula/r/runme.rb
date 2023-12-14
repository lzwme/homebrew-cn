class Runme < Formula
  desc "Execute commands inside your runbooks, docs, and READMEs"
  homepage "https://runme.dev/"
  url "https://ghproxy.com/https://github.com/stateful/runme/archive/refs/tags/v2.0.6.tar.gz"
  sha256 "bbbba83696f8af8bb28563d77733cc3c930e211f072b74c50edb066bbccfd806"
  license "Apache-2.0"
  head "https://github.com/stateful/runme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2b12ff0c2039c9b1cd05c222c4bf7b0f4bd9877f15539687462a64aeb3bf68a8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d7d974b4a03e9e124e1c4dc0830b33fa7a45039836ad44c2a22058db48163962"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9dbd33273af147cc5a7cedf27eaa041a66d5ba1eeabc87d0306a561bdb100afe"
    sha256 cellar: :any_skip_relocation, sonoma:         "d28828f36a4cdac3c61c50355e3562a65ff923013b2dd30abf72e64f4402209b"
    sha256 cellar: :any_skip_relocation, ventura:        "b684d342a5ba2338ce325dc02d0b8730811fc3bea504d2262f5f8494abaeb7a5"
    sha256 cellar: :any_skip_relocation, monterey:       "bfdfeb0de7aab935071f4fd135e92fd2dc7b464bdacb61199d97af112840fb4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c9210d4016825ecc0ad87fd82dc84966c0839156117030df3152726a3fed06ba"
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
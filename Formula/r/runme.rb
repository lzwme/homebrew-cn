class Runme < Formula
  desc "Execute commands inside your runbooks, docs, and READMEs"
  homepage "https://runme.dev/"
  url "https://ghproxy.com/https://github.com/stateful/runme/archive/refs/tags/v2.0.5.tar.gz"
  sha256 "99ddd8d35ea3b23fddd3a814d847d67f8591577caa7bf19851f35c8ae2f80cec"
  license "Apache-2.0"
  head "https://github.com/stateful/runme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "029571ad78a962be5764f2db8739cb84b9192962e79d1fb32110d83a8d1d7c00"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "97f369a0f65771d451c7cf739c00e595a71ac626b39e98adb4dc68f76a04bf14"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "77ff5b66f5deeb92c27f1fe5f93a0021e8bea921dfd06a225da0a5bb81b487e8"
    sha256 cellar: :any_skip_relocation, sonoma:         "cf172e1eabd78a5509e3321fdf6b4e435edc4e1a64199895eb64efecb42d0670"
    sha256 cellar: :any_skip_relocation, ventura:        "2667ec879c5c12a1e4ec32792dd87b618e9c2608c0034a4e6e53bca681b07dc2"
    sha256 cellar: :any_skip_relocation, monterey:       "99595000e778c7d12ec61dd71a849938b2f6aea04b17a46aa1ee4712682f10a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "900bb61a9329e1f1f022c62bf168b0a873d4a3b2e906f22c9988ee8381305b86"
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
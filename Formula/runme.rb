class Runme < Formula
  desc "Execute commands inside your runbooks, docs, and READMEs"
  homepage "https://runme.dev/"
  url "https://github.com/stateful/runme.git",
      tag:      "v1.5.2",
      revision: "dfe6bdf5f83595ecd3754d8a3178223451108c1f"
  license "Apache-2.0"
  head "https://github.com/stateful/runme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6c1e19fd90b824b2137bc41578368abe16d82d709c69fad0bd1e81997ccd52ae"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "54dc56deacc25618cb92e68d5a0658896f4fb2b726e2f3d1950089b9730f1703"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "51aaf635c93ebeb3477608217ba01bdf26a6f9eb8fad788e774b235d41ec6c07"
    sha256 cellar: :any_skip_relocation, ventura:        "a42d2844a16e035687228872cfe4f4579e40db934109220c250df21ab9ac7059"
    sha256 cellar: :any_skip_relocation, monterey:       "e537d135b9642a8bb75c2560b01038f5cc4558ea0cb5254497bfaae2ec686b90"
    sha256 cellar: :any_skip_relocation, big_sur:        "2fa35a60f59eff5acff5d2f17e0ea1a0b505fba45c61dfb10ae8ef32fcdc5824"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f0e0b32f5ded981323316956b09d66fb3b1bcdb202a1f5c975503e8beb6c22ae"
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
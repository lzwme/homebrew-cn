class Scalingo < Formula
  desc "CLI for working with Scalingo's PaaS"
  homepage "https://doc.scalingo.com/cli"
  url "https://ghfast.top/https://github.com/Scalingo/cli/archive/refs/tags/1.36.0.tar.gz"
  sha256 "f0b74970eec4db4d3518cac59a6d78c464e735471317bae283b39af6cb502d96"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1857584639d186ef71e54c6d85738a5209798a6b6e39825c1fa33aa4c8aa6739"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1857584639d186ef71e54c6d85738a5209798a6b6e39825c1fa33aa4c8aa6739"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1857584639d186ef71e54c6d85738a5209798a6b6e39825c1fa33aa4c8aa6739"
    sha256 cellar: :any_skip_relocation, sonoma:        "8c38708478d91a7d06fa6cb3e9ef8532deab5abaab57a789e8fe6b606c7e193d"
    sha256 cellar: :any_skip_relocation, ventura:       "8c38708478d91a7d06fa6cb3e9ef8532deab5abaab57a789e8fe6b606c7e193d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5341bc8a16c11bed01d9d475cb71660ab6ca417e1993b598a361b84b5c386d1e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "scalingo/main.go"

    bash_completion.install "cmd/autocomplete/scripts/scalingo_complete.bash" => "scalingo"
    zsh_completion.install "cmd/autocomplete/scripts/scalingo_complete.zsh" => "_scalingo"
  end

  test do
    expected = <<~END
      ┌───────────────────┬───────┐
      │ CONFIGURATION KEY │ VALUE │
      ├───────────────────┼───────┤
      │ region            │       │
      └───────────────────┴───────┘
    END
    assert_equal expected, shell_output("#{bin}/scalingo config")
  end
end
class Scalingo < Formula
  desc "CLI for working with Scalingo's PaaS"
  homepage "https://doc.scalingo.com/cli"
  url "https://ghproxy.com/https://github.com/Scalingo/cli/archive/1.29.0.tar.gz"
  sha256 "afea740cc01569d66213215d3a394c593c358eede35e48f0526b5d238e0d35bd"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7ebb715dfa1fbb95301c8ab8608d21a2f90e3c5a15888b39642469eb015e0a60"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7ebb715dfa1fbb95301c8ab8608d21a2f90e3c5a15888b39642469eb015e0a60"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7ebb715dfa1fbb95301c8ab8608d21a2f90e3c5a15888b39642469eb015e0a60"
    sha256 cellar: :any_skip_relocation, ventura:        "1547ccb507110b9e7ebc548205d46446d0e2291526ac010e4fd61a5da7957b40"
    sha256 cellar: :any_skip_relocation, monterey:       "1547ccb507110b9e7ebc548205d46446d0e2291526ac010e4fd61a5da7957b40"
    sha256 cellar: :any_skip_relocation, big_sur:        "1547ccb507110b9e7ebc548205d46446d0e2291526ac010e4fd61a5da7957b40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "35759722e0222819100ac06ea7ae53c3fe240620b4d2d8292196a7a72d437e22"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "scalingo/main.go"

    bash_completion.install "cmd/autocomplete/scripts/scalingo_complete.bash" => "scalingo"
    zsh_completion.install "cmd/autocomplete/scripts/scalingo_complete.zsh" => "_scalingo"
  end

  test do
    expected = <<~END
      +-------------------+-------+
      | CONFIGURATION KEY | VALUE |
      +-------------------+-------+
      | region            |       |
      +-------------------+-------+
    END
    assert_equal expected, shell_output("#{bin}/scalingo config")
  end
end
class Redress < Formula
  desc "Tool for analyzing stripped Go binaries compiled with the Go compiler"
  homepage "https:github.comgoretkredress"
  url "https:github.comgoretkredressarchiverefstagsv1.2.26.tar.gz"
  sha256 "70800329d3b3f6efff6b1e514c79dc8a73a2616f7f89bc93b89095469e88d0aa"
  license "AGPL-3.0-only"
  head "https:github.comgoretkredress.git", branch: "develop"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1e181df7d78f6d42ff8c7b996a72fe1f56bda11935cdd1815a469e5b597edcd4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1e181df7d78f6d42ff8c7b996a72fe1f56bda11935cdd1815a469e5b597edcd4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1e181df7d78f6d42ff8c7b996a72fe1f56bda11935cdd1815a469e5b597edcd4"
    sha256 cellar: :any_skip_relocation, sonoma:        "577a62ffc63bd2b590c151dee6015bf48993750b05fd76f992cda3691c46e0cd"
    sha256 cellar: :any_skip_relocation, ventura:       "577a62ffc63bd2b590c151dee6015bf48993750b05fd76f992cda3691c46e0cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "319e76382a930d1411825e152d532431d82530eb6d1c19fcbd7f7e25554b7f2c"
  end

  depends_on "go" => :build

  def install
    # https:github.comgoretkredressblobdevelopMakefile#L11-L14
    gore_version = File.read(buildpath"go.mod").scan(%r{goretkgore v(\S+)}).flatten.first

    ldflags = %W[
      -s -w
      -X main.redressVersion=#{version}
      -X main.goreVersion=#{gore_version}
      -X main.compilerVersion=#{Formula["go"].version}
    ]

    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin"redress", "completion")
  end

  test do
    assert_match "Version:  #{version}", shell_output("#{bin}redress version")

    test_module_root = "github.comgoretkredress"
    test_bin_path = bin"redress"

    output = shell_output("#{bin}redress info '#{test_bin_path}'")
    assert_match(Main root\s+#{Regexp.escape(test_module_root)}, output)
  end
end
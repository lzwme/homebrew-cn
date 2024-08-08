class Runme < Formula
  desc "Execute commands inside your runbooks, docs, and READMEs"
  homepage "https:runme.dev"
  url "https:github.comstatefulrunmearchiverefstagsv3.5.0.tar.gz"
  sha256 "2c714cc11dd64d74a464f44909623aa6a3af71f5d0f11c6f2bd219a3e9bd9f27"
  license "Apache-2.0"
  head "https:github.comstatefulrunme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "26fe16f4c804c380da73a916ab2b5dd9579e4eaecc0f4c1506947cf9d4055006"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "67ff9dd925a4d6008b3d45ea667bc8f70d2d21f46607e30f4889944e644208d1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7f5effefaaf167562143333a0386aae24ee564088413032ce3aa4c3a48c59620"
    sha256 cellar: :any_skip_relocation, sonoma:         "7452f2a033860582733b68f758e5178928d1b62a26dbb854ab91d75dad1c8812"
    sha256 cellar: :any_skip_relocation, ventura:        "6499829e0142d9aae24666fea9ba0ae2d1973c03c6f8b8cbcc5541b32d434f52"
    sha256 cellar: :any_skip_relocation, monterey:       "19c7e3be11716d6d0f9c3dbbf2bbbdef253353678c3f3feaefd34fbba750511f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b1de5fd3d6ed77794eb0cf0d98db4e9929e7e38a4ea0e96cbcabdf98cfafd1ea"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comstatefulrunmev3internalversion.BuildDate=#{time.iso8601}
      -X github.comstatefulrunmev3internalversion.BuildVersion=#{version}
      -X github.comstatefulrunmev3internalversion.Commit=#{tap.user}
    ]

    system "go", "build", "-o", bin, *std_go_args(ldflags:)
    generate_completions_from_executable(bin"runme", "completion")
  end

  test do
    system bin"runme", "--version"
    markdown = (testpath"README.md")
    markdown.write <<~EOS
      # Some Markdown

      Has some text.

      ```sh { name=foobar }
      echo "Hello World"
      ```
    EOS
    assert_match "Hello World", shell_output("#{bin}runme run --git-ignore=false foobar")
    assert_match "foobar", shell_output("#{bin}runme list --git-ignore=false")
  end
end
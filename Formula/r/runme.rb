class Runme < Formula
  desc "Execute commands inside your runbooks, docs, and READMEs"
  homepage "https:runme.dev"
  url "https:github.comstatefulrunmearchiverefstagsv2.2.2.tar.gz"
  sha256 "0b38a17a4c4c60699346e83ce7ac1ee72a7684b2b51b4553e020ef5e90a04d0f"
  license "Apache-2.0"
  head "https:github.comstatefulrunme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "01b7e2afbde0e12855dfe6018e527380c15cc6ab40b184fbbb09f428eff6c777"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8bdd6777afafe6c02e4d24afc456965b34446907c0f883cd795ebe4bde470712"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "02df3e8ec30e863b7ae61c0b44456f3c4b2c0df1360a076aa39770f19b676726"
    sha256 cellar: :any_skip_relocation, sonoma:         "1cdf4e5d2dfd7add095d0858e5822242dc3a80413081452f63d06e833e9cd562"
    sha256 cellar: :any_skip_relocation, ventura:        "556dd39e15a8b4ea12de9a6e6d75c821a0bf93bdcb1824a85ca44af5d8589a2b"
    sha256 cellar: :any_skip_relocation, monterey:       "c8f6968a32a8a0ad0b46ea4ea9d98f96f4b8da17255bc78cd77f63432ce620a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "81cfe83a1c925d8e8133265b189df19e88d4786373b5ccc619200b1a0788a7e5"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comstatefulrunmeinternalversion.BuildDate=#{time.iso8601}
      -X github.comstatefulrunmeinternalversion.BuildVersion=#{version}
      -X github.comstatefulrunmeinternalversion.Commit=#{tap.user}
    ]

    system "go", "build", "-o", bin, *std_go_args(ldflags: ldflags)
    generate_completions_from_executable(bin"runme", "completion")
  end

  test do
    system "#{bin}runme", "--version"
    markdown = (testpath"README.md")
    markdown.write <<~EOS
      # Some Markdown

      Has some text.

      ```sh { name=foobar }
      echo "Hello World"
      ```
    EOS
    assert_match "Hello World", shell_output("#{bin}runme run foobar")
    assert_match "foobar", shell_output("#{bin}runme list")
  end
end
class Runme < Formula
  desc "Execute commands inside your runbooks, docs, and READMEs"
  homepage "https:runme.dev"
  url "https:github.comrunmedevrunmearchiverefstagsv3.14.2.tar.gz"
  sha256 "af3d1fae4468f740ea9da6dffc9fbe010f391e0521377d46887bc5129f07a1fa"
  license "Apache-2.0"
  head "https:github.comrunmedevrunme.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "739c2ab7487eda1bf77256e97247c2e95d7e41c773ff0716c12a7919f0909207"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "739c2ab7487eda1bf77256e97247c2e95d7e41c773ff0716c12a7919f0909207"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "739c2ab7487eda1bf77256e97247c2e95d7e41c773ff0716c12a7919f0909207"
    sha256 cellar: :any_skip_relocation, sonoma:        "354c19bd2e50af6cafc4d5662db8abc9829fec9c6c5c4607e0cc24da7f14d3e0"
    sha256 cellar: :any_skip_relocation, ventura:       "354c19bd2e50af6cafc4d5662db8abc9829fec9c6c5c4607e0cc24da7f14d3e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8701c62de93683ee75f661f33edce685cd88e29e77f868dc8ac1ccaf96607e38"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comrunmedevrunmev3internalversion.BuildDate=#{time.iso8601}
      -X github.comrunmedevrunmev3internalversion.BuildVersion=#{version}
      -X github.comrunmedevrunmev3internalversion.Commit=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable(bin"runme", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}runme --version")
    markdown = (testpath"README.md")
    markdown.write <<~MARKDOWN
      # Some Markdown

      Has some text.

      ```sh { name=foobar }
      echo "Hello World"
      ```
    MARKDOWN
    assert_match "Hello World", shell_output("#{bin}runme run --git-ignore=false foobar")
    assert_match "foobar", shell_output("#{bin}runme list --git-ignore=false")
  end
end
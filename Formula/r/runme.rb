class Runme < Formula
  desc "Execute commands inside your runbooks, docs, and READMEs"
  homepage "https:runme.dev"
  url "https:github.comstatefulrunmearchiverefstagsv3.12.1.tar.gz"
  sha256 "af4cff202ba023addd4e6df841c69ca52f284832bb677bdd41f7f06834eae3ec"
  license "Apache-2.0"
  head "https:github.comstatefulrunme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bf91c82306b4bfdcf98141491b43c4740a1fb156cbc20e987f68d66785a539b7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bf91c82306b4bfdcf98141491b43c4740a1fb156cbc20e987f68d66785a539b7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bf91c82306b4bfdcf98141491b43c4740a1fb156cbc20e987f68d66785a539b7"
    sha256 cellar: :any_skip_relocation, sonoma:        "fb6245bcf11810d456a3ccdcec0ed1cd1e2305df145a9b187e6948be6f2ddbd8"
    sha256 cellar: :any_skip_relocation, ventura:       "fb6245bcf11810d456a3ccdcec0ed1cd1e2305df145a9b187e6948be6f2ddbd8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eba28b16dad2753293429a5b89322e43a21ba217d7f12bd8f18d98e8f871896b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comstatefulrunmev3internalversion.BuildDate=#{time.iso8601}
      -X github.comstatefulrunmev3internalversion.BuildVersion=#{version}
      -X github.comstatefulrunmev3internalversion.Commit=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable(bin"runme", "completion")
  end

  test do
    system bin"runme", "--version"
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
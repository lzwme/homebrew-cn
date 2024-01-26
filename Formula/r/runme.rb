class Runme < Formula
  desc "Execute commands inside your runbooks, docs, and READMEs"
  homepage "https:runme.dev"
  url "https:github.comstatefulrunmearchiverefstagsv2.2.1.tar.gz"
  sha256 "07ead76bdb310cf36cf24b9e252f4bef4a8408fa16ec1410a752d249de7bae9d"
  license "Apache-2.0"
  head "https:github.comstatefulrunme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0abca525fba633bd512379a702fca8b0b8146a92527deefc662aadb8205c9fe2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "675fcb090fb13ce6aade532f5cecc694a51f98af5d7c7b469027a94cc3c65c9d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "64c027cfcbc7bb2191467829f42c916064182e66000bb40f34201d5d6467bbc4"
    sha256 cellar: :any_skip_relocation, sonoma:         "43700ac484906c4179d8a90029ccd53e1455ea5f2b420e7f7807b8107d227c38"
    sha256 cellar: :any_skip_relocation, ventura:        "a0a3ed6491631f5980f95b7a0f3ea17927d16d67c280a45f0e4ef152a9f7da22"
    sha256 cellar: :any_skip_relocation, monterey:       "37be2da946d7da81a18ee414fbae4401f7e0de2ed9ac31137f6ccc0733eedae4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "704cc07ecb19f1262aed8c06c9284f35e4a88b84691fa45953c0e38cf389907e"
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
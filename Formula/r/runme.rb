class Runme < Formula
  desc "Execute commands inside your runbooks, docs, and READMEs"
  homepage "https:runme.dev"
  url "https:github.comstatefulrunmearchiverefstagsv3.3.1.tar.gz"
  sha256 "a17cb7f20480c7c3ac0022db0e80add54cccfc28605d11158f6bf3aa9d50e18d"
  license "Apache-2.0"
  head "https:github.comstatefulrunme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "23dd9d606f5e7f7e21a4030dc0d2c3858e6ee095d8444d8f6d91ed3092cdaa86"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "db45833404924b530455b879e9be47a29864b0641274adb35545cf4119bbf020"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "34aadcae330d451355c8fd8f1e82bbed735a6d3e642558e5deda42d14620b5c7"
    sha256 cellar: :any_skip_relocation, sonoma:         "b4acaa74654b1698ad1f326658674b99b36a78e9f72a64fcf8e6b87e6fd72c5d"
    sha256 cellar: :any_skip_relocation, ventura:        "9e03cdca8867f961363a39c0508696117f02674c55d444e7bffeafa457ebb18a"
    sha256 cellar: :any_skip_relocation, monterey:       "babc45665545055c5835c3ed86516f4e3ed4a7f70454b4d128c5cddcbb353514"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c95b9f69ec1b3ec646d21330d5e50379f82974779d9e94ea24d844ae808f01e4"
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
    system "#{bin}runme", "--version"
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
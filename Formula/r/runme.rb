class Runme < Formula
  desc "Execute commands inside your runbooks, docs, and READMEs"
  homepage "https:runme.dev"
  url "https:github.comstatefulrunmearchiverefstagsv2.2.0.tar.gz"
  sha256 "74054625cee7090acb571d372705776ad4c784600e7a3e0d137d5d133072af6f"
  license "Apache-2.0"
  head "https:github.comstatefulrunme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3d9555735826eaf127e2b9deaeb26bd06fd65bbe0f952797bcf34d8eb5aeb0f4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ad7e5dc7225cda775de79513a423baf147325470e570b3676eb56d2a3d845e53"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7a89c4c25bfd630b4a06928b2e098927861c33e8990d7e89b9d315703b987b3d"
    sha256 cellar: :any_skip_relocation, sonoma:         "8b309f113ba3cbba3f495d893e3a92147d7a37a173e7e494fe63e1399f218df1"
    sha256 cellar: :any_skip_relocation, ventura:        "e996bc791e475ff6e892c7acc67f58ceed875f835a0339dc6d9630f939c1ab03"
    sha256 cellar: :any_skip_relocation, monterey:       "9c88cd3241ad7a71f33f08a720b8ea5ed3023ea77b4f47dd266b68f30cd5ad81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8e2e8fad24eb32ca23956ea52a8b65523ab16a36e003e9bfacfdccc970a32a13"
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
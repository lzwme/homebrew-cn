class Revive < Formula
  desc "Fast, configurable, extensible, flexible, and beautiful linter for Go"
  homepage "https:revive.run"
  url "https:github.commgechevrevive.git",
      tag:      "v1.3.6",
      revision: "e33fb872bbf45934cd6110cc66995df1fdc3d84f"
  license "MIT"
  head "https:github.commgechevrevive.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4b918175c90a343bf93ac43db7ddd606637ff82339b752016f1231e3e595be98"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3ec44d8a6c36f03ba8c0f30e0f51d930ce1fb39391e2f08849b0ad7da054c806"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "efe4190bedddbd667fa4c43b108d4928af436b171cb45cc9af21570109e13f9c"
    sha256 cellar: :any_skip_relocation, sonoma:         "cd34952fd856a49b9d0dcdb712256e3110340de6fe93cc2bbc199d7f17684767"
    sha256 cellar: :any_skip_relocation, ventura:        "add62458ba3f53c869b03bf7f5730013ba300d991f5272f2354dc0f1ada8c976"
    sha256 cellar: :any_skip_relocation, monterey:       "a36dd637b5e0f25dceaeea0bfa7c33accb1b8ad17fb1e7f821bc0c2981acb04a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f088d59c9784dc90e59b2f06361e5e5b06eacd1295534e9fb42a66f91ff3d00c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X main.commit=#{Utils.git_head}
      -X main.date=#{time.iso8601}
      -X main.builtBy=#{tap.user}
    ]
    ldflags << "-X main.version=#{version}" unless build.head?
    system "go", "build", *std_go_args(ldflags: ldflags.join(" "))
  end

  test do
    (testpath"main.go").write <<~EOS
      package main

      import "fmt"

      func main() {
        my_string := "Hello from Homebrew"
        fmt.Println(my_string)
      }
    EOS
    output = shell_output("#{bin}revive main.go")
    assert_match "don't use underscores in Go names", output
  end
end
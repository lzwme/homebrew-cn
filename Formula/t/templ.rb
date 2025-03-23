class Templ < Formula
  desc "Language for writing HTML user interfaces in Go"
  homepage "https:templ.guide"
  url "https:github.coma-htemplarchiverefstagsv0.3.850.tar.gz"
  sha256 "1743f5cf8f2e26aa024444520b7713854847297f3d9f7ca21cd94b31b0182bb5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0b0fe5ebbdd05ddcc5cda26f9a451e79ebbf165b459fa5f4e5fcd1a27676e1f3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0b0fe5ebbdd05ddcc5cda26f9a451e79ebbf165b459fa5f4e5fcd1a27676e1f3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0b0fe5ebbdd05ddcc5cda26f9a451e79ebbf165b459fa5f4e5fcd1a27676e1f3"
    sha256 cellar: :any_skip_relocation, sonoma:        "cbf54f7429dd8f9181cee6623cf52a06240f2a1dcb9afd1b8b3aae0d48ebaf1b"
    sha256 cellar: :any_skip_relocation, ventura:       "cbf54f7429dd8f9181cee6623cf52a06240f2a1dcb9afd1b8b3aae0d48ebaf1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a79f25f13a8679bbc857caaeca00e706a417345b870312375d6c76fa8015e2f0"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmdtempl"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}templ version")

    (testpath"test.templ").write <<~TEMPL
      package main

      templ Test() {
        <p class="testing">Hello, World<p>
      }
    TEMPL

    output = shell_output("#{bin}templ generate -stdout -f #{testpath}test.templ")
    assert_match "func Test() templ.Component {", output
  end
end
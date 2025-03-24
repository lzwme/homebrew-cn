class Templ < Formula
  desc "Language for writing HTML user interfaces in Go"
  homepage "https:templ.guide"
  url "https:github.coma-htemplarchiverefstagsv0.3.856.tar.gz"
  sha256 "ac5e140fa9482c838234bfad9fd70f3e2f3f5f781e1e2cff252c392da10c0393"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bf9edecff2579c4cf98b49994be62ec0a3885c14406d0af8ed7457e3db4cb792"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bf9edecff2579c4cf98b49994be62ec0a3885c14406d0af8ed7457e3db4cb792"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bf9edecff2579c4cf98b49994be62ec0a3885c14406d0af8ed7457e3db4cb792"
    sha256 cellar: :any_skip_relocation, sonoma:        "28bac6e49380b8cc44a39b8f27aa4a4b3e696eeb37845c24edf84e6c4f3021f1"
    sha256 cellar: :any_skip_relocation, ventura:       "28bac6e49380b8cc44a39b8f27aa4a4b3e696eeb37845c24edf84e6c4f3021f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e2178c2cee00a5490a7e2412fea042a7e12823df9aa5c1c9f5240417a6d49626"
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
class K6 < Formula
  desc "Modern load testing tool, using Go and JavaScript"
  homepage "https:k6.io"
  url "https:github.comgrafanak6archiverefstagsv0.55.1.tar.gz"
  sha256 "8ddf7629748e246ab8396159a856b3da170345ffd180e4ecb296b6c96c23b9be"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7f33944835fff4700afacdeadb44a3adf3b4d1645025deb2872f19964c1b1b03"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7f33944835fff4700afacdeadb44a3adf3b4d1645025deb2872f19964c1b1b03"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7f33944835fff4700afacdeadb44a3adf3b4d1645025deb2872f19964c1b1b03"
    sha256 cellar: :any_skip_relocation, sonoma:        "9183e559ac42814a19ff2872d5493404fa80f4b586a1a3d1cef02558ea750299"
    sha256 cellar: :any_skip_relocation, ventura:       "9183e559ac42814a19ff2872d5493404fa80f4b586a1a3d1cef02558ea750299"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4648e94ab8d8b0faab63cd58378fd3e2d18e07cab56a1989993e2aa779ba3d16"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin"k6", "completion")
  end

  test do
    (testpath"whatever.js").write <<~JS
      export default function() {
        console.log("whatever");
      }
    JS

    assert_match "whatever", shell_output("#{bin}k6 run whatever.js 2>&1")
    assert_match version.to_s, shell_output("#{bin}k6 version")
  end
end
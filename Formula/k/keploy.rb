class Keploy < Formula
  desc "Testing Toolkit creates test-cases and data mocks from API calls, DB queries"
  homepage "https:keploy.io"
  url "https:github.comkeploykeployarchiverefstagsv2.4.1.tar.gz"
  sha256 "780f5b8a45070a45662f21b1aed3379e931aabb11ed376f0410bbab4e8bf52a8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "968a8cb72295c6600bc958680c31fc364efe2d22027e5d6da12b003c54fe0bdf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "968a8cb72295c6600bc958680c31fc364efe2d22027e5d6da12b003c54fe0bdf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "968a8cb72295c6600bc958680c31fc364efe2d22027e5d6da12b003c54fe0bdf"
    sha256 cellar: :any_skip_relocation, sonoma:        "e49f314d3ab2029e6cc546de86aa54c4dfc748b6dcfd4ac74b9ae4edbe392e5c"
    sha256 cellar: :any_skip_relocation, ventura:       "e49f314d3ab2029e6cc546de86aa54c4dfc748b6dcfd4ac74b9ae4edbe392e5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5bfd6078eb4522d4b38eaf0ced6fd945f669947811c3281ced2cf8fafde3ba3a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    system bin"keploy", "config", "--generate", "--path", testpath
    assert_match "# Generated by Keploy", (testpath"keploy.yml").read

    output = shell_output("#{bin}keploy templatize --path #{testpath}")
    assert_match "No test sets found to templatize", output

    assert_match version.to_s, shell_output("#{bin}keploy --version")
  end
end
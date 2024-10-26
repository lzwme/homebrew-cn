class MinijinjaCli < Formula
  desc "Render Jinja2 templates directly from the command-line to stdout"
  homepage "https:docs.rsminijinjalatestminijinja"
  url "https:github.commitsuhikominijinjaarchiverefstags2.4.0.tar.gz"
  sha256 "28f862b3805e71bd4537637d14e5f1b0af67dae84f13851af8bc5c2e416a539a"
  license "Apache-2.0"
  head "https:github.commitsuhikominijinja.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2268518274efc391385b3fb172124fb21c240b915e21a2670a34199034394a23"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "51d869cc4644b37cae43d90103f71a486cd31fd11c0c39d9e042338e2fbb60e0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e9a3c9ca63d61344ec7c5db929bb6da3d1736d195a4f34a46c1a55b0174095ae"
    sha256 cellar: :any_skip_relocation, sonoma:        "aebc256d6ade3d94c81b53116b9c95905b54b609cb908048c3b1bc1f6364ff07"
    sha256 cellar: :any_skip_relocation, ventura:       "dcb8ee381259cde5beaf7ea33b19124a25721bb933b46d080d439d19669aa3da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "837b3027559799552e901e827da4d45370db679751dede80a08995f83a332d26"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "minijinja-cli")
  end

  test do
    (testpath"test.jinja").write <<~EOS
      Hello {{ name }}
    EOS

    assert_equal "Hello Homebrew\n", shell_output("#{bin}minijinja-cli test.jinja --define name=Homebrew")
  end
end
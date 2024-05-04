class Yamlfmt < Formula
  desc "Extensible command-line tool to format YAML files"
  homepage "https:github.comgoogleyamlfmt"
  url "https:github.comgoogleyamlfmtarchiverefstagsv0.12.0.tar.gz"
  sha256 "20d43091de174e08998bff8ec666ff7f5d30cffee945580c1aadf3b801646889"
  license "Apache-2.0"
  head "https:github.comgoogleyamlfmt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "923eb16f1f1c41a49d484c7112b5fe8f62e2026e17c5e758e18a7074e469e642"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e4c9b9a06e6ed8caa5fd61ed7761b30a103e7c74a8de87dd8fa3ac11a41485ae"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "98d3563f96bcbcacf08445184f6f8eef46538d2251d881c4e80ab73d23b4cb0c"
    sha256 cellar: :any_skip_relocation, sonoma:         "d81fa9f4494bfa334efc6cc417ad0dab391800478b8bcda3674f129b2b810a38"
    sha256 cellar: :any_skip_relocation, ventura:        "8ae6aa7cfdf571aca305c6f5220c31c28e982324073a0fbebac863948835451a"
    sha256 cellar: :any_skip_relocation, monterey:       "f510b0764479226b01bba78e6b4d85491f78cefbc3aa6aef4a9c38cf67f40083"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b4f6700897f6e0b036b1c64e122d469216b848a59bcbe98c68f1412ac567cc1"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmdyamlfmt"
  end

  test do
    (testpath"test.yml").write <<~YAML
      foo: bar
    YAML
    system bin"yamlfmt", "-lint", "test.yml"
  end
end
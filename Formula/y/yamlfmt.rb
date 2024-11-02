class Yamlfmt < Formula
  desc "Extensible command-line tool to format YAML files"
  homepage "https:github.comgoogleyamlfmt"
  url "https:github.comgoogleyamlfmtarchiverefstagsv0.14.0.tar.gz"
  sha256 "351fe18bd821fa3ce3cda48f4f2270bf0b39104ca5dec5d99bd6c84841eb9bcb"
  license "Apache-2.0"
  head "https:github.comgoogleyamlfmt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c5594a8b9d5a83f76f8824a17cf83115644e021aeac1ad5a6365dda1dc0aaf80"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c5594a8b9d5a83f76f8824a17cf83115644e021aeac1ad5a6365dda1dc0aaf80"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c5594a8b9d5a83f76f8824a17cf83115644e021aeac1ad5a6365dda1dc0aaf80"
    sha256 cellar: :any_skip_relocation, sonoma:        "204c0cc28383f3da42f5feb60a40a5f73cd16d090b88260087194b09e2fccdcc"
    sha256 cellar: :any_skip_relocation, ventura:       "204c0cc28383f3da42f5feb60a40a5f73cd16d090b88260087194b09e2fccdcc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d6f799f0a7d20fee357cf4aca9f9108f423069072ac494bfbaffe722e795d4e5"
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
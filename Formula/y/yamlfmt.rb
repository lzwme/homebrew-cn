class Yamlfmt < Formula
  desc "Extensible command-line tool to format YAML files"
  homepage "https:github.comgoogleyamlfmt"
  url "https:github.comgoogleyamlfmtarchiverefstagsv0.14.0.tar.gz"
  sha256 "351fe18bd821fa3ce3cda48f4f2270bf0b39104ca5dec5d99bd6c84841eb9bcb"
  license "Apache-2.0"
  head "https:github.comgoogleyamlfmt.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "faf95e2728b5d61de469544a72c9334fb03535e9f3486b33aa83e5870146ca4a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "faf95e2728b5d61de469544a72c9334fb03535e9f3486b33aa83e5870146ca4a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "faf95e2728b5d61de469544a72c9334fb03535e9f3486b33aa83e5870146ca4a"
    sha256 cellar: :any_skip_relocation, sonoma:        "8d08a1ba3129da443233d70aa1aa4b2abe5fed23c6efb1f83a508381709007d0"
    sha256 cellar: :any_skip_relocation, ventura:       "8d08a1ba3129da443233d70aa1aa4b2abe5fed23c6efb1f83a508381709007d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2cde7e304c615321fc6e100901ba97110c790dc3fca5215cd43516964fb1609c"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:), ".cmdyamlfmt"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}yamlfmt -version")

    (testpath"test.yml").write <<~YAML
      foo: bar
    YAML
    system bin"yamlfmt", "-lint", "test.yml"
  end
end
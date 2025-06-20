class Yamlfmt < Formula
  desc "Extensible command-line tool to format YAML files"
  homepage "https:github.comgoogleyamlfmt"
  url "https:github.comgoogleyamlfmtarchiverefstagsv0.17.1.tar.gz"
  sha256 "5ec696bb4451bdee3354bcb01b22e6105937490b7e8ce5b72c28dddb0d3a414d"
  license "Apache-2.0"
  head "https:github.comgoogleyamlfmt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9967d4470f8013dba71c383bb30e8001408e94027087b1a870291b2cef820ecc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9967d4470f8013dba71c383bb30e8001408e94027087b1a870291b2cef820ecc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9967d4470f8013dba71c383bb30e8001408e94027087b1a870291b2cef820ecc"
    sha256 cellar: :any_skip_relocation, sonoma:        "9ebd685d2bb6f3b4e01ed8be2017f09a2f4be049fb9cbffb30f273e5d7ff3fd6"
    sha256 cellar: :any_skip_relocation, ventura:       "9ebd685d2bb6f3b4e01ed8be2017f09a2f4be049fb9cbffb30f273e5d7ff3fd6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "621fc16b6e71841c9daeb13d9e56c373f8816dad3c839eff7f1298d363b620ab"
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
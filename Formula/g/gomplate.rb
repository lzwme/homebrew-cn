class Gomplate < Formula
  desc "Command-line Golang template processor"
  homepage "https:gomplate.ca"
  url "https:github.comhairyhendersongomplatearchiverefstagsv4.0.1.tar.gz"
  sha256 "77647480ea3d67402a36d3c0ce64ffef9b230e8c89fa2f0e055814e6a76b45b5"
  license "MIT"
  head "https:github.comhairyhendersongomplate.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "017850cbe7669f2e4052b2bd56129d600badf0d65579411693a1ed9bcd357f80"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "19dca12ae9368b6c531e032e7be43cc0c0098ecd66d502f33e5682fa60cec555"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "66dccb7ee94a26c2756d3bce1975339e30a11f906bae6c2af2e3cc8c135f156d"
    sha256 cellar: :any_skip_relocation, sonoma:         "b35a9a50fc12635a90e7c9114f7052bdb909ad22e70cb428eb10bfd2fcdee427"
    sha256 cellar: :any_skip_relocation, ventura:        "4fd34815185cbc06dc74631305f2aa0940f63d20ebb675f14d13d293dc3ea56d"
    sha256 cellar: :any_skip_relocation, monterey:       "ca605d8f36456684529587d7790c88c57cd0fe5f242080625e6ddd075e746cf3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "01aae51742a3fcdd17f469396b8f3b2ee775fa0df2c1558fabc38a776f88140e"
  end

  depends_on "go" => :build

  def install
    system "make", "build", "VERSION=#{version}"
    bin.install "bingomplate" => "gomplate"
  end

  test do
    output = shell_output("#{bin}gomplate --version")
    assert_equal "gomplate version #{version}", output.chomp

    test_template = <<~EOS
      {{ range ("foo:bar:baz" | strings.SplitN ":" 2) }}{{.}}
      {{end}}
    EOS

    expected = <<~EOS
      foo
      bar:baz
    EOS

    assert_match expected, pipe_output("#{bin}gomplate", test_template, 0)
  end
end
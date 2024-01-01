class Gat < Formula
  desc "Cat alternative written in Go"
  homepage "https:github.comkoki-developgat"
  url "https:github.comkoki-developgatarchiverefstagsv0.15.0.tar.gz"
  sha256 "74c498a4f2324f5d3a7cdb8014623c1a4f324c8fd426ae5ee12304d3180cd5ab"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "029ace30db27dc8b366555f999fabe99e02c9a3e0363ec9c7354503823e75427"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2e851bb88e6a743d6ce7fdd912eb5d4f54739f116167c7990eda8585010b5d0b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6a3bfb04b4bc13b530b4cc6607751aa2e606b5ef7a7884eb9296362f9104b2c8"
    sha256 cellar: :any_skip_relocation, sonoma:         "1feb28aa323068122a9e8d4f9ce9737de3d20cb02c0cac195d45c291ffdee68d"
    sha256 cellar: :any_skip_relocation, ventura:        "dcd1adc00417794b831a6a18ea8111a5b8e542274a3b8ee2db749fcbf093d30e"
    sha256 cellar: :any_skip_relocation, monterey:       "613fad63fe53a7cf9f0ccc707a03abb3ac7bad044f53c3d54407e6b1b1c282d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7061aed02e1e1e72257090327673919c7321c0326c59fcebc697a60650f991a0"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.comkoki-developgatcmd.version=v#{version}")
  end

  test do
    (testpath"test.sh").write 'echo "hello gat"'

    assert_equal \
      "\e[38;5;231mecho\e[0m\e[38;5;231m \e[0m\e[38;5;186m\"hello gat\"\e[0m",
      shell_output("#{bin}gat --force-color test.sh")
    assert_match version.to_s, shell_output("#{bin}gat --version")
  end
end
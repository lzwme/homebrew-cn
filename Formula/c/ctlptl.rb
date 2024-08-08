class Ctlptl < Formula
  desc "Making local Kubernetes clusters fun and easy to set up"
  homepage "https:github.comtilt-devctlptl"
  url "https:github.comtilt-devctlptlarchiverefstagsv0.8.31.tar.gz"
  sha256 "96bb03232200e6df90af00951d4577b68abecbd0131c30e0aa9176441f98c070"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "69358443a5fc4f773692432ace1dc599c4f2e5bb995f8af822d91d472154cd20"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "65b125715d2c55ddad68d0ddf762963670349b821308465857912a2133a54f31"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d296a541961b55a52f3b472deab2467608e094534e75bb89e883c9af3d907dd8"
    sha256 cellar: :any_skip_relocation, sonoma:         "e7b0b6194754e03d20e101580abebc4c03e71b231af37cdd449f052619f1cd42"
    sha256 cellar: :any_skip_relocation, ventura:        "bb85d80c9159373064dac78c7caa95c7c849bb39a7b87a70e086818249cee3b5"
    sha256 cellar: :any_skip_relocation, monterey:       "90abe21d4246951c895f2af238c26d3e85675f766bc4c09fbc90f68e0b36d555"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3941bf6fc041b710e6c7e8b2350a732bc1787f46e9b19616b3695e7555d5e604"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), ".cmdctlptl"

    generate_completions_from_executable(bin"ctlptl", "completion")
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}ctlptl version")
    assert_equal "", shell_output("#{bin}ctlptl get")
    assert_match "not found", shell_output("#{bin}ctlptl delete cluster nonexistent 2>&1", 1)
  end
end
class Popeye < Formula
  desc "Kubernetes cluster resource sanitizer"
  homepage "https:popeyecli.io"
  url "https:github.comderailedpopeyearchiverefstagsv0.21.7.tar.gz"
  sha256 "5a2498ddf302c893741e4db55e434e9b644a348e8351bfc0e8b1abc425c773bb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "926fcdf0d7beead7736de7c859353999fcb3a853ffe7dc25914fd18c0cde808e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "93b98052e16619d283bd3e019906d9dae0b4b439ee75bd575c87e811ea12c6c8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5393d379bdd6ff694aacfd582305b8879f3bc57196917c1b5c82442e226d3bed"
    sha256 cellar: :any_skip_relocation, sonoma:        "5c6dec713676f689d5c50a1dde762892fe6ffb65d0ee085154d86f38e32ec7db"
    sha256 cellar: :any_skip_relocation, ventura:       "acfb14476324a0c90ba5d87b01836e6cb5b62c1853456b082e220fa383d945bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "66882d25da2853f1e7ba038426cb4f1353e2b08cf45997b12956289a0ccef73e"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comderailedpopeyecmd.version=#{version}
      -X github.comderailedpopeyecmd.commit=#{tap.user}
      -X github.comderailedpopeyecmd.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin"popeye", "completion")
  end

  test do
    output = shell_output("#{bin}popeye --save --out html --output-file report.html 2>&1", 1)
    assert_match "connect: connection refused", output

    assert_match version.to_s, shell_output("#{bin}popeye version")
  end
end